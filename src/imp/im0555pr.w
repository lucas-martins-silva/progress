&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0555PR 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0555pr MIM}
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
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0555PR
&GLOBAL-DEFINE Version        2.00.00.014
&GLOBAL-DEFINE VersionLayout  001


&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo 1,Sele‡Æo 2,Sele‡Æo 3,Parƒmetros

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   FILL-IN-1 ~
                              FILL-IN-2 ~
                              FILL-IN-3 ~
                              FILL-IN-4 ~
                              FILL-IN-5 ~
                              FILL-IN-6 ~
                              FILL-IN-7 ~
                              FILL-IN-8 ~
                              FILL-IN-9 ~
                              FILL-IN-10 ~
                              FILL-IN-11 ~
                              FILL-IN-12 ~
                              FILL-IN-13 ~
                              FILL-IN-14 ~
                              FILL-IN-15 ~
                              c-embarque-ini ~
                              c-embarque-fim


&GLOBAL-DEFINE page3Widgets   FILL-IN-16 ~
                              FILL-IN-17 ~
                              FILL-IN-18 ~
                              FILL-IN-19 ~
                              FILL-IN-20 ~
                              FILL-IN-21 ~
                              FILL-IN-22 ~
                              FILL-IN-23 ~
                              FILL-IN-24 ~
                              FILL-IN-25 ~
                              FILL-IN-26 ~
                              FILL-IN-27 ~
                              fc-fatura-ini ~
                              fc-fatura-fim ~
                              c-veiculo-transp-ini ~
                              c-veiculo-transp-fim
&GLOBAL-DEFINE page4Widgets   fi-veiculo-ini ~
                              fi-veiculo-fim ~
                              fi-entrada-ini ~
                              fi-entrada-fim
&GLOBAL-DEFINE page5Widgets   RADIO-SET-3 ~
                              RADIO-SET-1 ~
                              RADIO-SET-2
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    


/* Parameters Definitions ---                                           */

def output param iatraso       as integer no-undo.
def output param isituacao     as integer no-undo.
def output param isituacao-emb as integer no-undo.
def output param ddata-ini     as date    no-undo.
def output param ddata-fim     as date    no-undo.
def output param cest-ini      as char    no-undo.
def output param cest-fim      as char    no-undo.
def output param cproc-ini     as char    no-undo.
def output param cproc-fim     as char    no-undo.
def output param iexp-ini      AS integer FORMAT ">>>>>>>>9":U no-undo.
def output param iexp-fim      AS integer FORMAT ">>>>>>>>9":U no-undo.
def output param iitiner-ini   as integer no-undo.
def output param iitiner-fim   as integer no-undo.
def output param ipto-emb-ini  as integer no-undo.
def output param ipto-emb-fim  as integer no-undo.
def output param ipto-des-ini  as integer no-undo.
def output param ipto-des-fim  as integer no-undo.
def output param ilocal        as integer no-undo.
def output param igrupo-ini    as integer no-undo.
def output param igrupo-fim    as integer no-undo.
def output param cfam-ini      as char    no-undo.
def output param cfam-fim      as char    no-undo.
def output param citem-ini     as char    no-undo.
def output param citem-fim     as char    no-undo.
def output param cdecl-ini     as char    no-undo.
def output param cdecl-fim     as char    no-undo.
def output param cconhechouse-ini as char no-undo.
def output param cconhechouse-fim as char no-undo.
def output param cconhecmaster-ini as char no-undo.
def output param cconhecmaster-fim as char no-undo.
def output param c-fatura-ini  like invoice-emb-imp.nr-invoice no-undo.
def output param c-fatura-fim  like invoice-emb-imp.nr-invoice no-undo.
def output param cembarque-ini like embarque-imp.embarque no-undo.
def output param cembarque-fim like embarque-imp.embarque no-undo.
def output param cveiculo-transp-ini as char no-undo.
def output param cveiculo-transp-fim as char no-undo. 
&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
DEFINE OUTPUT PARAMETER i-PtoSolicLiIni     LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
DEFINE OUTPUT PARAMETER i-fiPtoSolicLiFim   LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
DEFINE OUTPUT PARAMETER c-fiLicencImportIni LIKE licenciam-import-oc.licenca-import        NO-UNDO.
DEFINE OUTPUT PARAMETER c-fiLicencImportFim LIKE licenciam-import-oc.licenca-import        NO-UNDO.
DEF OUTPUT PARAM c-veiculo-ini AS CHAR NO-UNDO.
DEF OUTPUT PARAM c-veiculo-fim AS CHAR NO-UNDO.
DEF OUTPUT PARAM dt-entrada-ini AS DATE NO-UNDO.
DEF OUTPUT PARAM dt-entrada-fim AS DATE NO-UNDO.
&ENDIF
def output param l-ok          as logical initial no no-undo.

/* Local Variable Definitions ---                                       */
def var h-bocx230b as handle no-undo.
def var c-via-transp as char no-undo.

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
    DEFINE VARIABLE h12         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h14         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h24         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h26         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h28         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h30         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE i-seq-erro  AS INTEGER    NO-UNDO.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-embarque-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .79 NO-UNDO.

DEFINE VARIABLE c-embarque-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Localiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-10 AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-11 AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-12 AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto de Embarque" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-13 AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-14 AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto de Nacionaliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-15 AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data de Chegada" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(12)":U 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-9 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiPtoSolicLiFim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiPtoSolicLiIni AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Solicita LI" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE c-veiculo-transp-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-veiculo-transp-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Veiculo Transp" 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88 NO-UNDO.

DEFINE VARIABLE fc-fatura-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fc-fatura-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Faturas" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiLicencImportFim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fiLicencImportIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Licenciamento Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-16 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-17 AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-18 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-19 AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-20 AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-21 AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-22 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Declara‡Æo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-23 AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-24 AS CHARACTER FORMAT "X(25)":U 
     LABEL "Conhecimento House" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-25 AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-26 AS CHARACTER FORMAT "X(25)":U 
     LABEL "Conhecimento Master" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-27 AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-46
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-47
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE fi-entrada-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-entrada-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data de Entrada" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-veiculo-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-veiculo-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Ve¡culo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-48
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-49
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-51
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Atrasados", 1,
"Adiantados", 2,
"Todos", 3
     SIZE 10.86 BY 2.79 NO-UNDO.

DEFINE VARIABLE RADIO-SET-2 AS INTEGER INITIAL 5 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Embarcado", 1,
"Embarcado Parcial", 2,
"Embarcado Total", 3,
"Encerrado", 4,
"Todos", 5
     SIZE 16 BY 4.58 NO-UNDO.

DEFINE VARIABLE RADIO-SET-3 AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Encerrado", 1,
"Encerrado", 2,
"Todos", 3
     SIZE 14.14 BY 2.79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 13 BY 3.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 5.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 17 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     FILL-IN-1 AT ROW 2.5 COL 19 COLON-ALIGNED
     FILL-IN-2 AT ROW 3.5 COL 19 COLON-ALIGNED
     FILL-IN-3 AT ROW 3.5 COL 45 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 4.5 COL 19 COLON-ALIGNED

     FILL-IN-5 AT ROW 4.5 COL 45 COLON-ALIGNED 
NO-LABEL
     c-embarque-ini AT ROW 5.5 COL 19 COLON-ALIGNED HELP
          "Informe C¢digo do Embarque"
     c-embarque-fim AT ROW 5.5 COL 45 COLON-ALIGNED HELP
          "Informe C¢digo do Embarque" NO-LABEL
     FILL-IN-6 AT ROW 6.5 COL 19 COLON-ALIGNED
     FILL-IN-7 AT ROW 6.5 COL 45 COLON-ALIGNED NO-LABEL
     FILL-IN-8 AT ROW 7.5 COL 19 COLON-ALIGNED
     FILL-IN-9 AT ROW 7.5 COL 45 COLON-ALIGNED NO-LABEL
     FILL-IN-10 AT ROW 8.5 COL 19 COLON-ALIGNED
     FILL-IN-11 AT ROW 8.5 COL 45 COLON-ALIGNED NO-LABEL
     fiPtoSolicLiIni AT ROW 9.5 COL 19 COLON-ALIGNED
     fiPtoSolicLiFim AT ROW 9.5 COL 45 COLON-ALIGNED NO-LABEL
     FILL-IN-12 AT ROW 9.5 COL 19 COLON-ALIGNED
     FILL-IN-13 AT ROW 9.5 COL 45 COLON-ALIGNED NO-LABEL
     FILL-IN-14 AT ROW 10.5 COL 19 COLON-ALIGNED
     FILL-IN-15 AT ROW 10.5 COL 45 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 3.5 COL 39
     IMAGE-10 AT ROW 8.5 COL 43
     IMAGE-11 AT ROW 9.5 COL 39
     IMAGE-12 AT ROW 9.5 COL 43
     IMAGE-13 AT ROW 10.5 COL 39
     IMAGE-14 AT ROW 10.5 COL 43
     IMAGE-15 AT ROW 4.5 COL 39
     IMAGE-16 AT ROW 4.5 COL 43
     IMAGE-2 AT ROW 3.5 COL 43
     IMAGE-3 AT ROW 5.5 COL 39
     IMAGE-4 AT ROW 5.5 COL 43
     IMAGE-44 AT ROW 9.5 COL 39
     IMAGE-45 AT ROW 9.5 COL 43
     IMAGE-5 AT ROW 6.5 COL 39
     IMAGE-6 AT ROW 6.5 COL 43
     IMAGE-7 AT ROW 7.5 COL 39
     IMAGE-8 AT ROW 7.5 COL 43
     IMAGE-9 AT ROW 8.5 COL 39
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage3
     FILL-IN-16 AT ROW 2.5 COL 18 COLON-ALIGNED
     FILL-IN-17 AT ROW 2.5 COL 53 COLON-ALIGNED NO-LABEL
     FILL-IN-18 AT ROW 3.5 COL 18 COLON-ALIGNED
     FILL-IN-19 AT ROW 3.5 COL 53 COLON-ALIGNED NO-LABEL
     FILL-IN-20 AT ROW 4.5 COL 18 COLON-ALIGNED
     FILL-IN-21 AT ROW 4.5 COL 53 COLON-ALIGNED NO-LABEL
     FILL-IN-22 AT ROW 5.5 COL 18 COLON-ALIGNED
     FILL-IN-23 AT ROW 5.5 COL 53 COLON-ALIGNED NO-LABEL
     fiLicencImportIni AT ROW 6.5 COL 18 COLON-ALIGNED
     fiLicencImportFim AT ROW 6.5 COL 53 COLON-ALIGNED NO-LABEL
     FILL-IN-24 AT ROW 6.5 COL 18 COLON-ALIGNED
     FILL-IN-25 AT ROW 6.5 COL 53 COLON-ALIGNED NO-LABEL
     FILL-IN-26 AT ROW 7.5 COL 18 COLON-ALIGNED
     FILL-IN-27 AT ROW 7.5 COL 53 COLON-ALIGNED NO-LABEL
     fc-fatura-ini AT ROW 8.5 COL 18 COLON-ALIGNED
     fc-fatura-fim AT ROW 8.5 COL 53 COLON-ALIGNED NO-LABEL
     c-veiculo-transp-ini AT ROW 9.5 COL 18 COLON-ALIGNED
     c-veiculo-transp-fim AT ROW 9.5 COL 53 COLON-ALIGNED NO-LABEL
     IMAGE-17 AT ROW 2.5 COL 47
     IMAGE-18 AT ROW 2.5 COL 51
     IMAGE-19 AT ROW 3.5 COL 47
     IMAGE-20 AT ROW 3.5 COL 51
     IMAGE-21 AT ROW 4.5 COL 47
     IMAGE-22 AT ROW 4.5 COL 51
     IMAGE-23 AT ROW 5.5 COL 47
     IMAGE-24 AT ROW 5.5 COL 51
     IMAGE-25 AT ROW 6.5 COL 47
     IMAGE-26 AT ROW 6.5 COL 51
     IMAGE-27 AT ROW 7.5 COL 47
     IMAGE-28 AT ROW 7.5 COL 51
     IMAGE-29 AT ROW 8.5 COL 47
     IMAGE-30 AT ROW 8.5 COL 51
     IMAGE-42 AT ROW 9.5 COL 47
     IMAGE-43 AT ROW 9.5 COL 51
     IMAGE-46 AT ROW 6.5 COL 47
     IMAGE-47 AT ROW 6.5 COL 51
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage4
     fi-veiculo-ini AT ROW 2.5 COL 21.86 COLON-ALIGNED
     fi-veiculo-fim AT ROW 2.5 COL 45 COLON-ALIGNED NO-LABEL
     fi-entrada-ini AT ROW 3.5 COL 21.86 COLON-ALIGNED
     fi-entrada-fim AT ROW 3.5 COL 45 COLON-ALIGNED NO-LABEL
     IMAGE-48 AT ROW 2.5 COL 39
     IMAGE-49 AT ROW 2.5 COL 43
     IMAGE-50 AT ROW 3.5 COL 39
     IMAGE-51 AT ROW 3.5 COL 43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage5
     RADIO-SET-3 AT ROW 3.92 COL 12.72 NO-LABEL
     RADIO-SET-1 AT ROW 3.92 COL 36 NO-LABEL
     RADIO-SET-2 AT ROW 4.13 COL 54.86 NO-LABEL
     "Situa‡Æo:" VIEW-AS TEXT
          SIZE 6.72 BY .88 AT ROW 3 COL 57
     "Processos:" VIEW-AS TEXT
          SIZE 7.57 BY .88 AT ROW 3 COL 37
     "Situa‡Æo Embarque:" VIEW-AS TEXT
          SIZE 14.14 BY .79 AT ROW 3 COL 12.72
     RECT-1 AT ROW 3.38 COL 34.72
     RECT-2 AT ROW 3.42 COL 54
     RECT-3 AT ROW 3.38 COL 11
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fPage0:HANDLE
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE
       FRAME fPage4:FRAME = FRAME fPage0:HANDLE
       FRAME fPage5:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FRAME fPage3
   Custom                                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    /*assign l-ok = no.*/
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wReport
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN cxbo/bocx230b.p persistent set h-bocx230b.

    ASSIGN FRAME fPage5
        radio-set-1
        radio-set-2
        radio-set-3.

    ASSIGN FRAME fpage3
        fill-in-16
        fill-in-17
        fill-in-18
        fill-in-19
        fill-in-20
        fill-in-21
        fill-in-22
        fill-in-23
        fill-in-24
        fill-in-25
        fill-in-26
        fill-in-27
        c-veiculo-transp-ini
        c-veiculo-transp-fim
        fc-fatura-ini
        fc-fatura-fim
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
            fiLicencImportIni
            fiLicencImportFim
        &ENDIF.
    ASSIGN FRAME fpage2
        fill-in-1
        fill-in-2
        fill-in-3
        fill-in-4
        fill-in-5
        fill-in-6
        fill-in-7
        fill-in-8
        fill-in-9
        fill-in-10
        fill-in-11
        fill-in-12
        fill-in-13
        fill-in-14
        fill-in-15
        c-embarque-ini
        c-embarque-fim
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
            fiPtoSolicLiIni
            fiPtoSolicLiFim
        &ENDIF.
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
    ASSIGN FRAME fpage4
          fi-veiculo-ini
          fi-veiculo-fim
          fi-entrada-ini
          fi-entrada-fim.
    &endif.

    RUN validateParametros in h-bocx230b (input string(fill-in-2),
                                            input string(fill-in-3),
                                            input fill-in-4,
                                            input fill-in-5,
                                            input fill-in-6,
                                            input fill-in-7,
                                            input fill-in-8,
                                            input fill-in-9,
                                            input string(fill-in-10),
                                            input string(fill-in-11),
                                            input string(fill-in-12),
                                            input string(fill-in-13),
                                            input string(fill-in-14),
                                            input string(fill-in-15),
                                            input string(fill-in-1),
                                            input string(fill-in-16),
                                            input string(fill-in-17),
                                            input string(fill-in-18),
                                            input string(fill-in-19),
                                            input string(fill-in-20),
                                            input string(fill-in-21),
                                            input string(fill-in-22),
                                            input string(fill-in-23),
                                            input string(fill-in-24),
                                            input string(fill-in-25),
                                            input string(fill-in-26),
                                            input string(fill-in-27),
                                            input fc-fatura-ini,
                                            input fc-fatura-fim,
                                            input c-embarque-ini,
                                            input c-embarque-fim,
                                            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                                            INPUT fi-veiculo-ini,
                                            INPUT fi-veiculo-fim,
                                            INPUT fi-entrada-ini,
                                            INPUT fi-entrada-fim,
                                            &endif
                                            output table RowErrors).

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
        IF fiPtoSolicLiIni > fiPtoSolicLiFim THEN DO:
            FIND LAST RowErrors NO-ERROR.
            IF AVAIL RowErrors THEN
                ASSIGN i-seq-erro = RowErrors.errorSequence + 1.
            ELSE 
                ASSIGN i-seq-erro = 1.

            {utp/ut-field.i mgcex itinerario cdn-pto-solic-licenciam-import 1}
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 142,
                               INPUT RETURN-VALUE).
            CREATE RowErrors.
            ASSIGN RowErrors.errorSequence    = i-seq-erro
                   RowErrors.errorNumber      = 142
                   RowErrors.errorDescription = RETURN-VALUE.
        END.
        IF fiLicencImportIni  > fiLicencImportFim THEN DO:
            FIND LAST RowErrors NO-ERROR.
            IF AVAIL RowErrors THEN
                ASSIGN i-seq-erro = RowErrors.errorSequence + 1.
            ELSE 
                ASSIGN i-seq-erro = 1.

            {utp/ut-liter.i Licenciamento_Importa‡Æo}
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 142,
                               INPUT RETURN-VALUE).
            CREATE RowErrors.
            ASSIGN RowErrors.errorSequence    = i-seq-erro
                   RowErrors.errorNumber      = 142
                   RowErrors.errorDescription = RETURN-VALUE.
        END.
    &ENDIF

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
        LEAVE.
    END.
    ELSE DO:
        ASSIGN iatraso = radio-set-1
               isituacao = radio-set-2
               isituacao-emb = radio-set-3
               ddata-ini = fill-in-2
               ddata-fim = fill-in-3
               cest-ini = fill-in-4
               cest-fim = fill-in-5
               cproc-ini = fill-in-6
               cproc-fim = fill-in-7
               iexp-ini = fill-in-8
               iexp-fim = fill-in-9
               iitiner-ini = fill-in-10
               iitiner-fim = fill-in-11
               ipto-emb-ini = fill-in-12
               ipto-emb-fim = fill-in-13
               ipto-des-ini = fill-in-14
               ipto-des-fim = fill-in-15
               ilocal = fill-in-1
               igrupo-ini = fill-in-16
               igrupo-fim = fill-in-17
               cfam-ini = fill-in-18
               cfam-fim = fill-in-19
               citem-ini = fill-in-20
               citem-fim = fill-in-21
               cdecl-ini = fill-in-22
               cdecl-fim = fill-in-23
               cconhechouse-ini = fill-in-24
               cconhechouse-fim = fill-in-25
               cconhecmaster-ini = fill-in-26
               cconhecmaster-fim = fill-in-27
               c-fatura-ini = fc-fatura-ini
               c-fatura-fim = fc-fatura-fim
               cembarque-ini = c-embarque-ini
               cembarque-fim = c-embarque-fim
               cveiculo-transp-ini = c-veiculo-transp-ini
               cveiculo-transp-fim = c-veiculo-transp-fim
               l-ok          = yes.
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
        ASSIGN i-PtoSolicLiIni = fiPtoSolicLiIni   
               i-fiPtoSolicLiFim = fiPtoSolicLiFim   
               c-fiLicencImportIni = fiLicencImportIni 
               c-fiLicencImportFim = fiLicencImportFim.

        IF param-global.log-modul-eq = YES THEN
        ASSIGN c-veiculo-ini = fi-veiculo-ini
               c-veiculo-fim = fi-veiculo-fim
               dt-entrada-ini = fi-entrada-ini
               dt-entrada-fim = fi-entrada-fim.
        &endif

        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.

    delete procedure h-bocx230b.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN

        DO WITH FRAME fPage2:

            ASSIGN fiPtoSolicLiIni:SENSITIVE = YES 
                   fiPtoSolicLiFim:SENSITIVE = YES
                   fiPtoSolicLiIni:SCREEN-VALUE = "0"
                   fiPtoSolicLiFim:SCREEN-VALUE = "99999".

            ASSIGN h12 = FILL-IN-12:SIDE-LABEL-HANDLE
                   h14 = FILL-IN-14:SIDE-LABEL-HANDLE.

            ASSIGN image-11:ROW   = 10.5
                   image-12:ROW   = 10.5
                   FILL-IN-12:ROW = 10.5
                   FILL-IN-13:ROW = 10.5
                   image-13:ROW   = 11.5
                   image-14:ROW   = 11.5
                   FILL-IN-14:ROW = 11.5
                   FILL-IN-15:ROW = 11.5.

            ASSIGN h12:ROW = 10.5
                   h14:ROW = 11.5.
        END.
        DO WITH FRAME fPage3:

            ASSIGN fiLicencImportIni:SENSITIVE = YES 
                   fiLicencImportFim:SENSITIVE = YES
                   fiLicencImportFim:SCREEN-VALUE = "ZZZZZZZZZZZZZZZZZZZZ".

            ASSIGN h24 = FILL-IN-24:SIDE-LABEL-HANDLE
                   h26 = FILL-IN-26:SIDE-LABEL-HANDLE
                   h28 = fc-fatura-ini:SIDE-LABEL-HANDLE
                   h30 = c-veiculo-transp-ini:SIDE-LABEL-HANDLE.

            ASSIGN image-25:ROW   = 7.5
                   image-26:ROW   = 7.5
                   FILL-IN-24:ROW = 7.5
                   FILL-IN-25:ROW = 7.5
                   image-27:ROW   = 8.5
                   image-28:ROW   = 8.5
                   FILL-IN-26:ROW = 8.5
                   FILL-IN-27:ROW = 8.5
                   image-29:ROW   = 9.5
                   image-30:ROW   = 9.5
                   fc-fatura-ini:ROW = 9.5
                   fc-fatura-fim:ROW = 9.5
                   image-42:ROW   = 10.5
                   image-43:ROW   = 10.5
                   c-veiculo-transp-ini:ROW = 10.5
                   c-veiculo-transp-fim:ROW = 10.5.

            ASSIGN h24:ROW = 7.5
                   h26:ROW = 8.5
                   h28:ROW = 9.5
                   h30:ROW = 10.5.
        END.
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF  param-global.log-modul-eq = NO THEN
            RUN deleteFolder IN hFolder(3).
    &else
        RUN deleteFolder IN hFolder(3).
    &ENDIF

    {utp/ut-liter.i Estabelecimento * R}
    assign FILL-IN-4:LABEL IN FRAME fPage2 = TRIM(RETURN-VALUE).

    &IF "{&mguni_version}" >= "2.071" &THEN
       assign FILL-IN-5:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZ".
    &ELSE
       assign FILL-IN-5:SCREEN-VALUE IN FRAME fPage2 = "ZZZ".      
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).

        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/

    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).

        /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.ordem = tt-digita.ordem 
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).

            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.

            return error.
        end.

        /*:T As demais valida‡äes devem ser feitas aqui */
        if  tt-digita.ordem <= 0 then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ordem:HANDLE in browse brDigita.

            reposition brDigita to rowid r-tt-digita.

            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.

            return error.
        end.

    end.


    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */



    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.classifica      = input frame fPage3 rsClassif
           tt-param.desc-classifica = entry((tt-param.classifica - 1) * 2 + 1, 
                                            rsClassif:radio-buttons in frame fPage3).

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */



    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i xxp/xx9999rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "":U).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.

    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).                               
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 

    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i xxp/xx9999rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}

end.
&ENDIF
      */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

