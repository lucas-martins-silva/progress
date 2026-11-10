&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i IM3101 2.00.00.042 } /*** "010042" 09/02/2026 14:53:20 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im3101 MIM}
&ENDIF

/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{cxbo/bocx310a.i tt-desp-embarque}
{cxbo/bocx310a.i tt-desp-embarque-aux}
{cxbo/bocx220h.i tt-selecao-embarque}
{imp/im0100x.i   tt-parametros}
{inbo/boin090.i  tt-docum-est} 
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}
{include/boerrtab.i}
{cxbo/bocx250.i tt-param-imp}
{imp/im3101.i} /*tt-impostos-despesa*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM3101
&GLOBAL-DEFINE Version        2.00.00.042
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetro,ATS,Impostos

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2 ~
                              bt-sel-embarques ~
                              btDespesas ~
                              btLimpar ~
                              btConferencia
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btDelete 
&GLOBAL-DEFINE page2Fields    c-embarque ~
                              i-cod-emitente ~
                              c-serie-docto ~
                              cb-tipo-comprov ~
                              da-dt-trans ~
                              c-estab-fisc ~
                              da-dt-cotacao ~
                              d-cotacao ~
                              tg-nff ~
                              c-cod-estabel ~
                              c-nro-docto ~
                              c-nat-operacao ~
                              da-dt-emissao ~
                              cb-cod-observa ~
                              c-ct-transit ~
                              c-sc-transit ~
                              f-timbrado ~
                              f-dt-vto ~
                              f-estab-fat ~
                              f-pto-vda ~
                              c-observacao ~
                              tg-atualiz-receb-auto
&GLOBAL-DEFINE page4Fields    i-cdn-pto-emis ~
                              c-cod-estabel-ats ~
                              c-num-autoriz-sri ~
                              d-dat-autoriz

&GLOBAL-DEFINE page5Fields    

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-impostos NO-UNDO
  FIELD cod-tax   LIKE tipo-tax.cod-tax 
  FIELD descricao LIKE tipo-tax.descricao 
  FIELD tax-perc  LIKE tipo-tax.tax-perc
  INDEX id cod-tax.


DEFINE BUFFER b-tt-impostos-despesa FOR tt-impostos-despesa.
DEFINE BUFFER b-tt-desp-embarque    FOR tt-desp-embarque.

DEF VAR cLista              AS CHAR                      NO-UNDO.
DEF VAR h-boin682           AS HANDLE                    NO-UNDO.
DEF VAR h-boad098           AS HANDLE                    NO-UNDO.
DEF VAR h-bodi217           AS HANDLE                    NO-UNDO.
DEF VAR h-bocx220h          AS HANDLE                    NO-UNDO.
DEF VAR h-im3101a           AS HANDLE                    NO-UNDO.
DEF VAR h-boar2134          AS HANDLE                    NO-UNDO.
DEF VAR c-formato           AS CHAR                      NO-UNDO.
DEF VAR c-retorno           AS CHAR                      NO-UNDO.
DEF VAR c-descricao         LIKE tipo-tax.descricao      NO-UNDO.
DEF VAR de-tax-perc         LIKE tipo-tax.tax-perc       NO-UNDO.
DEF VAR de-perc-percepcao   LIKE tipo-tax.perc-percepcao NO-UNDO.

DEF VAR c-embarque-anterior LIKE embarque-imp.embarque     NO-UNDO.
DEF VAR i-cod-desp-ini      LIKE desp-imp.cod-desp         NO-UNDO.
DEF VAR i-cod-desp-fim      LIKE desp-imp.cod-desp         NO-UNDO.
DEF VAR i-fornec-desp-ini   LIKE desp-imp.cod-emitente     NO-UNDO. 
DEF VAR i-fornec-desp-fim   LIKE desp-imp.cod-emitente     NO-UNDO.
DEF VAR i-pto-controle-ini  LIKE pto-contr.cod-pto-contr   NO-UNDO.
DEF VAR i-pto-controle-fim  LIKE pto-contr.cod-pto-contr   NO-UNDO.
DEF VAR l-ok-c              AS LOG                         NO-UNDO.
DEF VAR l-embarque-invalido AS LOG                         NO-UNDO.
DEF VAR l-executar          AS LOG                         NO-UNDO.
DEF VAR i-empresa           LIKE param-global.empresa-prin NO-UNDO.
DEF VAR l-log1              AS LOG                         NO-UNDO.
DEF VAR h-bopy2003          AS HANDLE                      NO-UNDO.
DEF VAR h-arg0020a          AS HANDLE                      NO-UNDO.
DEF VAR v-cod-tax-aux       LIKE tipo-tax.cod-tax          NO-UNDO. 
DEF VAR l-abert-prog        AS LOG INIT YES                NO-UNDO.
DEF VAR c-cb-tipo-comprov-aux AS CHAR                      NO-UNDO. 
DEF VAR c-cod-estabel-aux   AS CHAR                        NO-UNDO.
DEF VAR c-cod-emitente-aux  AS CHAR                        NO-UNDO.
    

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE            SHARED VARIABLE hWenController AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD embarque          AS CHAR
    FIELD cod-estabel       AS CHAR
    FIELD cod-emitente      AS CHAR
    FIELD docto             AS CHAR
    FIELD serie             AS CHAR
    FIELD nat-operacao      AS CHAR 
    FIELD data-trans        AS DATE
    FIELD data-emissao      AS DATE
    FIELD ccod-estabel-fisc AS CHAR
    FIELD cod-observa       AS CHAR
    FIELD data-cotacao      AS DATE
    FIELD nff               AS CHAR
    FIELD ct-transit        AS CHAR
    FIELD sc-transit        AS CHAR.       
    
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHAR
    FIELD usuario            AS CHAR
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD classifica         AS INTEGER
    FIELD c-cod-estabel-ini  AS CHAR
    FIELD c-cod-estabel-fim  AS CHAR
    FIELD i-cod-emitente-ini AS INTEGER format "999999999"
    FIELD i-cod-emitente-fim AS INTEGER format "999999999"
    FIELD c-nro-docto-ini    AS CHAR
    FIELD c-nro-docto-fim    AS CHAR
    FIELD c-serie-docto-ini  AS CHAR
    FIELD c-serie-docto-fim  AS CHAR
    FIELD c-nat-operacao-ini AS CHAR
    FIELD c-nat-operacao-fim AS CHAR
    FIELD da-dt-trans-ini    AS DATE
    FIELD da-dt-trans-fim    AS DATE.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD r-docum-est AS ROWID.
    
DEF VAR raw-param AS RAW NO-UNDO.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita   AS RAW.    

DEFINE VARIABLE c-empresa   LIKE param-global.empresa-prin NO-UNDO.
DEFINE VARIABLE c-estabelec AS CHARACTER                   NO-UNDO.
{cdp/cdunif001.i} /* Vari†veis da unificaá∆o de conceito Conta Cont†bil e Centro de Custo */

{cdp/cd4300.i3}  /*Variòveis para o cd4300.i4 */
{cdp/cd0101.i50} /*Variòveis para o re1001b.i51*/

define variable l-ok                        as logical                     no-undo.
define variable c-embarque-ini              LIKE embarque-imp.embarque     no-undo. 
define variable c-embarque-fim              LIKE embarque-imp.embarque     no-undo initial "ZZZZZZZZZZZZZZZZ". 
define variable dt-nacionalizacao-ini       as date format "99/99/9999"    no-undo initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF. 
define variable dt-nacionalizacao-fim       as date format "99/99/9999"    no-undo initial 12/31/9999. 
define variable c-processo-ini              as char format "x(12)"         no-undo.                              
define variable c-processo-fim              as char format "x(12)"         no-undo initial "ZZZZZZZZZZZZ".       
define variable dt-di-ini                   as date format "99/99/9999"    no-undo initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.                
define variable dt-di-fim                   as date format "99/99/9999"    no-undo initial 12/31/9999.           
define variable i-itinerario-ini            as int  format ">>,>>9"        no-undo.                              
define variable i-itinerario-fim            as int  format ">>,>>9"        no-undo initial 99999.                
define variable i-exportador-ini            as int  format ">>>>>>>>9"     no-undo.                              
define variable i-exportador-fim            as int  format ">>>>>>>>9"     no-undo initial 999999999.
define variable l-mostra-embarq-sem-despesa as log                         no-undo. 

DEFINE VARIABLE h-bocx250                   AS HANDLE                      NO-UNDO.

{local/arg/arg0020.i} /*tt-imposto para localizaá∆o Argentina*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-impostos-despesa

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-impostos-despesa.cod-tax tt-impostos-despesa.descricao tt-impostos-despesa.tax-perc tt-impostos-despesa.vl-base-me tt-impostos-despesa.vl-imposto-me   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-impostos-despesa.cod-tax ~
tt-impostos-despesa.tax-perc ~
tt-impostos-despesa.vl-base-me ~
tt-impostos-despesa.vl-imposto-me   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-impostos-despesa
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-impostos-despesa
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-impostos-despesa
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-impostos-despesa.
&Scoped-define TABLES-IN-QUERY-brDigita tt-impostos-despesa
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-impostos-despesa


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar bt-sel-embarques btDespesas ~
btLimpar btOK btCancel btConferencia btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-sel-embarques 
     IMAGE-UP FILE "IMAGE/im-ran":U
     LABEL "Sel" 
     SIZE 4.14 BY 1.21 TOOLTIP "Seleá∆o de Embarques".

DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btConferencia 
     LABEL "Conferància" 
     SIZE 10 BY 1.

DEFINE BUTTON btDespesas 
     IMAGE-UP FILE "IMAGE/im-fpv.bmp":U
     LABEL "Sel" 
     SIZE 4.14 BY 1.21 TOOLTIP "Seleá∆o de Despesas".

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btLimpar 
     IMAGE-UP FILE "image/im-esto.bmp":U
     LABEL "Limpar" 
     SIZE 4.14 BY 1.21 TOOLTIP "Limpar Embarques e Despesas".

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-cod-observa AS CHARACTER FORMAT "X(256)" 
     LABEL "Cod Observaá∆o":R15 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-comprov AS CHARACTER FORMAT "X(256)" 
     LABEL "Tipo Comprov":R15 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE c-observacao AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 60.57 BY 2.29 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento":R18 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-transit AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Transit¢ria" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-embarque AS CHARACTER FORMAT "X(16)" 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-estab-fisc AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabel Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Operaá∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-transit AS CHARACTER FORMAT "x(20)" 
     LABEL "Sub-Conta Transit" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "SÇrie":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-cotacao AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Cotaá∆o Moeda":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-cotacao AS DEC FORMAT ">>>,>>9.9999999999":U  
     LABEL "Cotaá∆o Moeda" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.     
     
DEFINE VARIABLE da-dt-emissao AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Emiss∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-trans AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Transaá∆o":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-dt-vto AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Vto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-estab-fat AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Estab Fat" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE f-pto-vda AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Pto Vda" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE VARIABLE f-timbrado AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Timbrado" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-ccusto AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-conta AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-d-val-gravad AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Gravado" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-d-val-isento AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Isento" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-d-val-nao-gravad AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "N∆o Gravado" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Fornecedor":R10 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE tg-atualiz-receb-auto AS LOGICAL INITIAL no 
     LABEL "Atualiza Documento no Recebimento Automaticamente" 
     VIEW-AS TOGGLE-BOX
     SIZE 57.43 BY .83.

DEFINE VARIABLE tg-nff AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Fatura":L22 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ats AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento do Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-num-autoriz-sri AS CHARACTER FORMAT "X(49)":U 
     LABEL "N£mero Autorizaá∆o SRI" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE d-dat-autoriz AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Autorizaá∆o SRI" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-pto-emis AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Ponto de Emiss∆o do Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Incluir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Eliminar" 
     SIZE 15 BY 1
     FONT 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-impostos-despesa SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-impostos-despesa.cod-tax   WIDTH 10.00
      tt-impostos-despesa.descricao
      tt-impostos-despesa.tax-perc
      tt-impostos-despesa.vl-base-me
      tt-impostos-despesa.vl-imposto-me
         
    ENABLE
      tt-impostos-despesa.cod-tax
      tt-impostos-despesa.tax-perc
      tt-impostos-despesa.vl-base-me
      tt-impostos-despesa.vl-imposto-me
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-sel-embarques AT ROW 17.79 COL 39.29 HELP
          "Seleá∆o de Embarques" WIDGET-ID 4
     btDespesas AT ROW 17.79 COL 43.72 HELP
          "Seleá∆o de Despesas" WIDGET-ID 2
     btLimpar AT ROW 17.79 COL 48.14 WIDGET-ID 6
     btOK AT ROW 17.92 COL 2
     btCancel AT ROW 17.92 COL 12.29
     btConferencia AT ROW 17.92 COL 22.57
     btHelp2 AT ROW 17.92 COL 80
     rtToolBar AT ROW 17.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 18.54
         FONT 1.

DEFINE FRAME fPage2
     c-embarque AT ROW 1.21 COL 10.86 HELP
          "N£mero do Embarque"
     c-cod-estabel AT ROW 1.21 COL 59.72 COLON-ALIGNED
     i-cod-emitente AT ROW 2.21 COL 17.43 COLON-ALIGNED
     c-nome-abrev AT ROW 2.21 COL 27.72 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     c-nro-docto AT ROW 2.21 COL 59.72 COLON-ALIGNED
     c-serie-docto AT ROW 3.21 COL 17.43 COLON-ALIGNED
     c-nat-operacao AT ROW 3.21 COL 59.72 COLON-ALIGNED
     da-dt-trans AT ROW 4.21 COL 17.43 COLON-ALIGNED
     da-dt-emissao AT ROW 4.21 COL 59.72 COLON-ALIGNED
     c-estab-fisc AT ROW 5.21 COL 17.43 COLON-ALIGNED HELP
          "Estabelecimento para geraá∆o dos documentos fiscais"
     cb-cod-observa AT ROW 5.21 COL 59.72 COLON-ALIGNED HELP
          "C¢digo de observaá∆o da nota fiscal"
     da-dt-cotacao AT ROW 6.21 COL 17.43 COLON-ALIGNED
     d-cotacao AT ROW 6.21 COL 40.14 COLON-ALIGNED
     tg-nff AT ROW 6.21 COL 61.72 HELP
          "Sim  ou  Nao"
     c-ct-transit AT ROW 7.21 COL 17.43 COLON-ALIGNED
     fi-c-desc-conta AT ROW 7.21 COL 33.72 COLON-ALIGNED NO-LABEL
     c-sc-transit AT ROW 8.21 COL 17.43 COLON-ALIGNED
     fi-c-desc-ccusto AT ROW 8.21 COL 33.72 COLON-ALIGNED NO-LABEL
     fi-d-val-gravad AT ROW 9.21 COL 17.43 COLON-ALIGNED HELP
          "Valor Gravado"
     cb-tipo-comprov AT ROW 9.21 COL 17.43 COLON-ALIGNED HELP
          "C¢digo de observaá∆o da nota fiscal" WIDGET-ID 4
     fi-d-val-nao-gravad AT ROW 9.21 COL 42.43 COLON-ALIGNED HELP
          "Valor N∆o Gravado"
     fi-d-val-isento AT ROW 9.21 COL 64.43 COLON-ALIGNED HELP
          "Valor Isento"
     f-estab-fat AT ROW 10.21 COL 17.43 COLON-ALIGNED WIDGET-ID 2
     f-pto-vda AT ROW 10.21 COL 31.86 COLON-ALIGNED
     f-timbrado AT ROW 10.21 COL 46.57 COLON-ALIGNED
     f-dt-vto AT ROW 10.21 COL 62.86 COLON-ALIGNED
     c-observacao AT ROW 11.21 COL 19.43 NO-LABEL
     tg-atualiz-receb-auto AT ROW 13.83 COL 19.57 WIDGET-ID 6
     "Observaá∆o:" VIEW-AS TEXT
          SIZE 8.86 BY .63 TOOLTIP "Observaá∆o:" AT ROW 11.17 COL 10.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13.96
         FONT 1.

DEFINE FRAME fPage4
     i-cdn-pto-emis AT ROW 2 COL 25 COLON-ALIGNED WIDGET-ID 10
     c-cod-estabel-ats AT ROW 3 COL 25 COLON-ALIGNED WIDGET-ID 12
     c-num-autoriz-sri AT ROW 4 COL 25 COLON-ALIGNED WIDGET-ID 14
     d-dat-autoriz AT ROW 5 COL 25 COLON-ALIGNED WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btDelete AT ROW 10 COL 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13.96
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.54
         WIDTH              = 90.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-embarque IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-ccusto IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-conta IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-d-val-gravad IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-d-val-gravad:HIDDEN IN FRAME fPage2           = TRUE.

/* SETTINGS FOR FILL-IN fi-d-val-isento IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-d-val-isento:HIDDEN IN FRAME fPage2           = TRUE.

/* SETTINGS FOR FILL-IN fi-d-val-nao-gravad IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-d-val-nao-gravad:HIDDEN IN FRAME fPage2           = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-impostos-despesa.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-impostos-despesa then
            delete tt-impostos-despesa.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-impostos-despesa.cod-tax  
                tt-impostos-despesa.descricao 
                tt-impostos-despesa.tax-perc  with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-impostos-despesa.
        assign input browse brDigita tt-impostos-despesa.cod-tax  
               input browse brDigita tt-impostos-despesa.descricao
               input browse brDigita tt-impostos-despesa.tax-perc
               input browse brDigita tt-impostos-despesa.vl-base-me               
               input browse brDigita tt-impostos-despesa.vl-imposto-me.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-impostos-despesa THEN DO:
            assign input browse brDigita tt-impostos-despesa.cod-tax  
                   input browse brDigita tt-impostos-despesa.descricao
                   input browse brDigita tt-impostos-despesa.tax-perc
                   input browse brDigita tt-impostos-despesa.vl-base-me               
                   input browse brDigita tt-impostos-despesa.vl-imposto-me.
        END.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-sel-embarques
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sel-embarques wReport
ON CHOOSE OF bt-sel-embarques IN FRAME fpage0 /* Sel */
DO:
    def var h-boad107 as handle no-undo.
    def var c-return  as char   no-undo.
    
    assign c-cod-estabel:sensitive in frame fPage2 = yes.

    if  not valid-handle(h-boad107) then
        run adbo/boad107.p persistent set h-boad107.
    run findCodigo in h-boad107 (input c-cod-estabel:screen-value in frame fPage2,
                                 output c-return).
    if c-cod-estabel:screen-value in frame fPage2 = "" OR 
       c-return <> "":U then do:
        {utp/ut-table.i mgadm Estabelec 1}
        run utp/ut-msgs.p (input "show":U,
                           input 2,
                           input return-value).
        if  valid-handle (h-boad107) then do:
            delete procedure h-boad107.
            assign h-boad107 = ?.
        end.
        apply "entry":U to c-cod-estabel in frame fPage2.
        return no-apply.
    end.
    if  valid-handle (h-boad107) then do:
        delete procedure h-boad107.
        assign h-boad107 = ?.
    end.

    assign wReport:sensitive = no.
    run imp/im3101b.w (input c-cod-estabel:screen-value in frame fPage2,
                       input-output c-embarque-ini,              
                       input-output c-embarque-fim,               
                       input-output dt-nacionalizacao-ini,        
                       input-output dt-nacionalizacao-fim,        
                       input-output c-processo-ini,               
                       input-output c-processo-fim,               
                       input-output dt-di-ini,                    
                       input-output dt-di-fim,                    
                       input-output i-itinerario-ini,             
                       input-output i-itinerario-fim,             
                       input-output i-exportador-ini,             
                       input-output i-exportador-fim,
                       input-output l-mostra-embarq-sem-despesa,
                       input-output table tt-selecao-embarque,
                       output l-ok). 

    if  l-ok then do:
        for each tt-desp-embarque:
            delete tt-desp-embarque.
        end.
        for each tt-desp-embarque-aux:
            delete tt-desp-embarque-aux.
        end.
    end.
    
    if  can-find (first  tt-selecao-embarque
                   where tt-selecao-embarque.marca = "X") then DO:
        
            assign c-embarque:screen-value in frame fPage2 = "" 
                   c-embarque:sensitive    in frame fPage2 = no
                   c-cod-estabel:sensitive in frame fPage2 = no
                   tg-nff:CHECKED IN FRAME fPage2     = YES
                   tg-nff:sensitive in frame fPage2 = no.
    END.
    else do:
        assign c-embarque:screen-value in frame fPage2 = c-embarque-anterior 
               c-embarque:sensitive    in frame fPage2 = YES
               c-cod-estabel:sensitive in frame fPage2 = yes.

        IF i-pais-impto-usuario <> 9 /* Paraguai */ THEN
               ASSIGN tg-nff:sensitive in frame fPage2 = YES.

        if  not valid-handle (h-bocx220h) then
            run cxbo/bocx220h.p persistent set h-bocx220h.
        /* selecao usando o embarque informado em tela */
        run carregaTtSelecaoEmbarque in this-procedure.
        if  valid-handle (h-bocx220h) then do:
            delete procedure h-bocx220h.
            assign h-bocx220h = ?.
        end.
    end.

    assign wReport:sensitive = yes.
    apply 'entry':U to c-embarque in frame fPage2.
    APPLY "value-changed":U TO tg-nff IN FRAME fPage2.
    RUN pi-mostra-conta-trans.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Incluir */
DO:
    assign btDelete:SENSITIVE in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 THEN
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-impostos-despesa.
        open query brDigita for each tt-impostos-despesa.
        APPLY "entry":U TO tt-impostos-despesa.cod-tax IN BROWSE brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConferencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConferencia wReport
ON CHOOSE OF btConferencia IN FRAME fpage0 /* Conferància */
DO:
    ASSIGN l-executar = NO.

    DO  TRANSACTION:
        RUN piExecute.

        EMPTY TEMP-TABLE tt-parametros.
        
        UNDO, LEAVE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Eliminar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-impostos-despesa.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btDelete:SENSITIVE in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btDespesas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDespesas wReport
ON CHOOSE OF btDespesas IN FRAME fpage0 /* Sel */
DO:

    if  not can-find(first  tt-selecao-embarque
                     where tt-selecao-embarque.marca = "X") THEN 
        RUN carregaTTSelecaoEmbarque.
    
    ASSIGN INPUT FRAME fPage2 i-cod-emitente.

    IF i-cod-emitente = 0 THEN DO:
        {utp/ut-liter.i Fornecedor}
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 265,
                           INPUT RETURN-VALUE).

        APPLY "entry":U TO i-cod-emitente in frame fPage2.
        RETURN NO-APPLY.
    END.

    IF  NOT CAN-FIND(FIRST tt-selecao-embarque
                     WHERE tt-selecao-embarque.marca = "X") THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 34477,
                           INPUT "").
        
        APPLY "entry":U TO c-embarque IN FRAME fPage2.
        RETURN NO-APPLY.
    END.

    ASSIGN wReport:SENSITIVE = NO
           l-ok-c            = NO.

    IF NOT CAN-FIND(FIRST tt-desp-embarque-aux) THEN DO:
        FOR EACH tt-desp-embarque:
            ASSIGN tt-desp-embarque.selecionado = NO. 
        END.
    END.
    
    ASSIGN i-fornec-desp-ini = INPUT FRAME fPage2 i-cod-emitente
           i-fornec-desp-fim = INPUT FRAME fPage2 i-cod-emitente.

    RUN imp/im3101c.w (INPUT i-cod-emitente,
                       INPUT        TABLE tt-selecao-embarque,
                       INPUT-OUTPUT TABLE tt-desp-embarque,
                       INPUT-OUTPUT i-cod-desp-ini,    
                       INPUT-OUTPUT i-cod-desp-fim,    
                       INPUT-OUTPUT i-fornec-desp-ini, 
                       INPUT-OUTPUT i-fornec-desp-fim, 
                       INPUT-OUTPUT i-pto-controle-ini,
                       INPUT-OUTPUT i-pto-controle-fim,
                       INPUT-OUTPUT l-ok-c,
                       INPUT-OUTPUT TABLE tt-desp-embarque-aux).

    ASSIGN wReport:SENSITIVE = YES.
    
    IF i-pais-impto-usuario = 2 THEN
        RUN piCalculaImpostoARG.
    APPLY 'ENTRY':U TO btDespesas IN FRAME fPage0.
    
    RUN piCotacaoMoeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLimpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpar wReport
ON CHOOSE OF btLimpar IN FRAME fpage0 /* Limpar */
DO:
  EMPTY TEMP-TABLE tt-selecao-embarque.
  EMPTY TEMP-TABLE tt-desp-embarque.
  EMPTY TEMP-TABLE tt-desp-embarque-aux.

  ASSIGN c-embarque:SENSITIVE IN FRAME fPage2    = YES
         c-cod-estabel:SENSITIVE IN FRAME fPage2 = YES
         tg-nff:SENSITIVE IN FRAME fPage2        = YES.

  RUN piCotacaoMoeda.         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
    IF  VALID-HANDLE(h-boar2134) THEN DO:
        CREATE tt-dados.
        ASSIGN tt-dados.embarque          = c-embarque:SCREEN-VALUE IN FRAME fPage2     
               tt-dados.cod-estabel       = c-cod-estabel:SCREEN-VALUE IN FRAME fPage2
               tt-dados.cod-emitente      = i-cod-emitente:SCREEN-VALUE IN FRAME fPage2
               tt-dados.docto             = c-nro-docto:SCREEN-VALUE IN FRAME fPage2
               tt-dados.serie             = c-serie-docto:SCREEN-VALUE IN FRAME fPage2
               tt-dados.nat-operacao      = c-nat-operacao:SCREEN-VALUE IN FRAME fPage2
               tt-dados.data-trans        = DATE(da-dt-trans:SCREEN-VALUE IN FRAME fPage2)
               tt-dados.data-emissao      = DATE(da-dt-emissao:SCREEN-VALUE IN FRAME fPage2)
               tt-dados.ccod-estabel-fisc = c-estab-fisc:SCREEN-VALUE IN FRAME fPage2
               tt-dados.cod-observa       = cb-cod-observa:SCREEN-VALUE IN FRAME fPage2
               tt-dados.data-cotacao      = DATE(da-dt-cotacao:SCREEN-VALUE IN FRAME fPage2)
               tt-dados.nff               = tg-nff:SCREEN-VALUE IN FRAME fPage2
               tt-dados.ct-transit        = c-ct-transit:SCREEN-VALUE IN FRAME fPage2
               tt-dados.sc-transit        = c-sc-transit:SCREEN-VALUE IN FRAME fPage2.

          RUN validaIm3101 IN h-boar2134 (INPUT 1, 
                                          INPUT YES,
                                          INPUT TABLE tt-dados ,
                                          OUTPUT l-log1 ).
    END.
    ASSIGN l-executar = YES.

    DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        RUN piExecute.
        EMPTY TEMP-TABLE tt-parametros.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON F5 OF c-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-cod-estabel"
                         &Frame1="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:
   IF c-embarque:SCREEN-VALUE IN FRAME fPage2    <> "" AND
      c-cod-estabel:SCREEN-VALUE IN FRAME fPage2 <> "" THEN 
        RUN pi-busca-dados-embarque.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ct-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit wReport
ON ENTRY OF c-ct-transit IN FRAME fPage2 /* Conta Transit¢ria */
DO:
    ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit wReport
ON F5 OF c-ct-transit IN FRAME fPage2 /* Conta Transit¢ria */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    ASSIGN INPUT FRAME fPage2 da-dt-trans.

    IF  da-dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = da-dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2*/
                                                   INPUT  "CEP":U,            /* MODULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                   INPUT  dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    IF  v_des_cta_ctbl <> "" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit wReport
ON LEAVE OF c-ct-transit IN FRAME fPage2 /* Conta Transit¢ria */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    ASSIGN INPUT FRAME fPage2 da-dt-trans.
    IF  da-dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = da-dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    ASSIGN v_cod_cta_ctbl = INPUT FRAME fPage2 c-ct-transit.
    
    /* Busca dados da conta cont†bil */
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA?ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF  RETURN-VALUE = "OK" THEN DO:
        /* Busca formato de apresentaá∆o da conta cont†bil */
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  dt-trans-aux,         /* DATA DE TRANSACAO */
                                                           OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).   /* ERROS */
        
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
               fi-c-desc-conta:SCREEN-VALUE IN FRAME fPage2 = v_des_cta_ctbl.
        
        /* Aplica a mascara no campo */
        IF  p_cod_format_cta_ctbl <> "" THEN
            ASSIGN SELF:FORMAT = p_cod_format_cta_ctbl.

        /* Verifica se a conta utiliza centro de custo */
        ASSIGN c-estabelec = INPUT FRAME fPage2 c-cod-estabel.
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                           INPUT  dt-trans-aux,       /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        IF  NOT p_log_ccusto THEN
            ASSIGN c-sc-transit:SCREEN-VALUE     IN FRAME fPage2 = ""
                   fi-c-desc-ccusto:SCREEN-VALUE IN FRAME fPage2 = ""
                   c-sc-transit:SENSITIVE        IN FRAME fPage2 = NO.
        ELSE DO:
            ASSIGN c-sc-transit:SENSITIVE   IN FRAME fPage2 = YES.
            APPLY "ENTRY":U TO c-sc-transit IN FRAME fPage2.
        END.
    END.
    ELSE DO:
        ASSIGN fi-c-desc-conta:SCREEN-VALUE  IN FRAME fPage2 = ""
               fi-c-desc-ccusto:SCREEN-VALUE IN FRAME fPage2 = ""
               c-sc-transit:SCREEN-VALUE     IN FRAME fPage2 = ""
               c-sc-transit:SENSITIVE        IN FRAME fPage2 = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-transit wReport
ON MOUSE-SELECT-DBLCLICK OF c-ct-transit IN FRAME fPage2 /* Conta Transit¢ria */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-embarque wReport
ON F5 OF c-embarque IN FRAME fPage2 /* Embarque */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z04cx220.w"
                         &FieldZoom1="embarque"
                         &FieldScreen1="c-embarque"
                         &Frame1="fPage2"
                         &FieldZoom2="cod-estabel"
                         &FieldScreen2="c-cod-estabel"
                         &Frame2="fPage2"
                         &FieldZoom3="cod-estab-fisc"
                         &FieldScreen3="c-estab-fisc"
                         &Frame3="fPage2"
                         &FieldZoom4="ct-transit-import"
                         &FieldScreen4="c-ct-transit"
                         &Frame4="fPage2"
                         &FieldZoom5="sc-transit-import"
                         &FieldScreen5="c-sc-transit"
                         &Frame5="fPage2"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-embarque wReport
ON LEAVE OF c-embarque IN FRAME fPage2 /* Embarque */
DO:

    IF c-embarque:SCREEN-VALUE IN FRAME fPage2    <> "" AND
       c-cod-estabel:SCREEN-VALUE IN FRAME fPage2 <> "" THEN 
       
        RUN pi-busca-dados-embarque.
    
    IF  VALID-HANDLE(h-boar2134) THEN DO:
        CREATE tt-dados.
        ASSIGN tt-dados.embarque          = c-embarque:SCREEN-VALUE IN FRAME fPage2     
               tt-dados.cod-estabel       = c-cod-estabel:SCREEN-VALUE IN FRAME fPage2
               tt-dados.cod-emitente      = i-cod-emitente:SCREEN-VALUE IN FRAME fPage2
               tt-dados.docto             = c-nro-docto:SCREEN-VALUE IN FRAME fPage2
               tt-dados.serie             = c-serie-docto:SCREEN-VALUE IN FRAME fPage2
               tt-dados.nat-operacao      = c-nat-operacao:SCREEN-VALUE IN FRAME fPage2
               tt-dados.data-trans        = DATE(da-dt-trans:SCREEN-VALUE IN FRAME fPage2)
               tt-dados.data-emissao      = DATE(da-dt-emissao:SCREEN-VALUE IN FRAME fPage2)
               tt-dados.ccod-estabel-fisc = c-estab-fisc:SCREEN-VALUE IN FRAME fPage2
               tt-dados.cod-observa       = cb-cod-observa:SCREEN-VALUE IN FRAME fPage2
               tt-dados.data-cotacao      = DATE(da-dt-cotacao:SCREEN-VALUE IN FRAME fPage2)
               tt-dados.nff               = tg-nff:SCREEN-VALUE IN FRAME fPage2
               tt-dados.ct-transit        = c-ct-transit:SCREEN-VALUE IN FRAME fPage2
               tt-dados.sc-transit        = c-sc-transit:SCREEN-VALUE IN FRAME fPage2.

          RUN validaIm3101 IN h-boar2134 (INPUT 1, 
                                          INPUT NO,
                                          INPUT TABLE tt-dados ,
                                          OUTPUT l-log1 ).
    END.

    IF  c-embarque-anterior <> INPUT FRAME fPage2 c-embarque THEN DO:
        EMPTY TEMP-TABLE tt-selecao-embarque.
        EMPTY TEMP-TABLE tt-desp-embarque.
        EMPTY TEMP-TABLE tt-desp-embarque-aux.
        
        ASSIGN c-embarque-anterior = c-embarque:SCREEN-VALUE IN FRAME fPage2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-embarque wReport
ON MOUSE-SELECT-DBLCLICK OF c-embarque IN FRAME fPage2 /* Embarque */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estab-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-fisc wReport
ON F5 OF c-estab-fisc IN FRAME fPage2 /* Estabel Fiscal */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-estab-fisc"
                         &Frame1="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-fisc wReport
ON MOUSE-SELECT-DBLCLICK OF c-estab-fisc IN FRAME fPage2 /* Estabel Fiscal */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON F5 OF c-nat-operacao IN FRAME fPage2 /* Nat Operaá∆o */
DO:
    
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                       &campo="c-nat-operacao"
                       &campozoom="nat-operacao"
                       &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON LEAVE OF c-nat-operacao IN FRAME fPage2 /* Nat Operaá∆o */
DO:
  IF  VALID-HANDLE(h-boar2134) THEN DO:
        IF l-log1 = YES  THEN DO:
             CREATE tt-dados.
             ASSIGN tt-dados.embarque          = c-embarque:SCREEN-VALUE IN FRAME fPage2     
                    tt-dados.cod-estabel       = c-cod-estabel:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.cod-emitente      = i-cod-emitente:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.docto             = c-nro-docto:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.serie             = c-serie-docto:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.nat-operacao      = c-nat-operacao:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.data-trans        = DATE(da-dt-trans:SCREEN-VALUE IN FRAME fPage2)
                    tt-dados.data-emissao      = DATE(da-dt-emissao:SCREEN-VALUE IN FRAME fPage2)
                    tt-dados.ccod-estabel-fisc = c-estab-fisc:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.cod-observa       = cb-cod-observa:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.data-cotacao      = DATE(da-dt-cotacao:SCREEN-VALUE IN FRAME fPage2)
                    tt-dados.nff               = tg-nff:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.ct-transit        = c-ct-transit:SCREEN-VALUE IN FRAME fPage2
                    tt-dados.sc-transit        = c-sc-transit:SCREEN-VALUE IN FRAME fPage2.
             
               RUN validaIm3101 IN h-boar2134 (INPUT 2, 
                                               INPUT NO,
                                               INPUT TABLE tt-dados ,
                                               OUTPUT l-log1 ).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON MOUSE-SELECT-DBLCLICK OF c-nat-operacao IN FRAME fPage2 /* Nat Operaá∆o */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit wReport
ON ENTRY OF c-sc-transit IN FRAME fPage2 /* Sub-Conta Transit */
DO:
    ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit wReport
ON F5 OF c-sc-transit IN FRAME fPage2 /* Sub-Conta Transit */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    ASSIGN INPUT FRAME fPage2 da-dt-trans.
    IF  da-dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = da-dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    ASSIGN c-estabelec = INPUT FRAME fPage2 c-cod-estabel.
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT c-empresa,           /* Empresa */
                                                   INPUT c-estabelec,         /* Estabelecimento */
                                                   INPUT NO,                  /* Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                  /* Unidade de Negocio*/
                                                   INPUT "",                  /* Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,      /* CΩdigo da Conta*/
                                                   INPUT "",                  /* CΩdigo do Plano de Centro de Custo*/
                                                   INPUT dt-trans-aux,        /* Data da Transacao*/
                                                   OUTPUT v_cod_ccusto,       /* Codigo CCusto*/
                                                   OUTPUT v_des_ccusto,       /* Descricao CCusto*/
                                                   OUTPUT TABLE tt_log_erro). /* Erros*/

    IF  v_des_ccusto <> "" THEN
        ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto
               fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit wReport
ON LEAVE OF c-sc-transit IN FRAME fPage2 /* Sub-Conta Transit */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    ASSIGN INPUT FRAME fPage2 da-dt-trans.
    IF  da-dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = da-dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_ccusto = INPUT FRAME fPage2 c-sc-transit.
    
    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  v_cod_ccusto,       /* CCUSTO */
                                               INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */
                                               OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        /* Busca m†scara para o campo centro de custo */
        RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,           /* EMPRESA EMS2 */
                                                       INPUT  "",                  /* PLANO CONTAS */
                                                       INPUT  dt-trans-aux,        /* DATA DE TRANSACAO */ 
                                                       OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                       OUTPUT TABLE tt_log_erro).  /* ERROS */
        
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME fPage2 = v_des_ccusto.
        /* Aplica a m†scara no campo */
        IF  p_cod_format_ccusto <> "" THEN
            ASSIGN SELF:FORMAT IN FRAME fPage2 = p_cod_format_ccusto.
    END.
    ELSE
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME fPage2 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-transit wReport
ON MOUSE-SELECT-DBLCLICK OF c-sc-transit IN FRAME fPage2 /* Sub-Conta Transit */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-docto wReport
ON F5 OF c-serie-docto IN FRAME fPage2 /* SÇrie */
DO:
    assign l-implanta = yes.    
    {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                       &campo="c-serie-docto"
                       &campozoom="serie"
                       &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-docto wReport
ON MOUSE-SELECT-DBLCLICK OF c-serie-docto IN FRAME fPage2 /* SÇrie */
DO:
    APPLY "F5":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-dt-cotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dt-cotacao wReport
ON LEAVE OF da-dt-cotacao IN FRAME fPage2 /* Data Cotaá∆o Moeda */
DO: 
    RUN piCotacaoMoeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-d-val-gravad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-d-val-gravad wReport
ON LEAVE OF fi-d-val-gravad IN FRAME fPage2 /* Gravado */
DO:
    RUN piCalculaImpostoARG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-d-val-isento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-d-val-isento wReport
ON LEAVE OF fi-d-val-isento IN FRAME fPage2 /* Isento */
DO:
    RUN piCalculaImpostoARG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-d-val-nao-gravad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-d-val-nao-gravad wReport
ON LEAVE OF fi-d-val-nao-gravad IN FRAME fPage2 /* N∆o Gravado */
DO:
    RUN piCalculaImpostoARG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente wReport
ON F5 OF i-cod-emitente IN FRAME fPage2 /* Fornecedor */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo="i-cod-emitente"
                       &campozoom="cod-emitente"
                       &campo2="c-nome-abrev"
                       &campozoom2="nome-abrev"
                       &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente wReport
ON LEAVE OF i-cod-emitente IN FRAME fPage2 /* Fornecedor */
DO: 
    RUN pi-busca-dados-embarque.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = INT(i-cod-emitente:SCREEN-VALUE) NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN c-nome-abrev:SCREEN-VALUE = emitente.nome-abrev.
        ELSE
            ASSIGN c-nome-abrev:SCREEN-VALUE = ''.
    END.
    ELSE 
        {method/referencefields.i &HandleDBOLeave="h-boad098"
                              &FindMethod="findCodigo"  
                              &KeyValue1="input frame fPage2 i-cod-emitente"
                              &FieldName1="nome-abrev"
                              &FieldScreen1="c-nome-abrev"
                              &Frame1="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente wReport
ON MOUSE-SELECT-DBLCLICK OF i-cod-emitente IN FRAME fPage2 /* Fornecedor */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-atualiz-receb-auto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-atualiz-receb-auto wReport
ON VALUE-CHANGED OF tg-atualiz-receb-auto IN FRAME fPage2 /* Atualiza Documento no Recebimento Automaticamente */
DO:
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-nff
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-nff wReport
ON VALUE-CHANGED OF tg-nff IN FRAME fPage2 /* Nota Fiscal Fatura */
DO:
  RUN pi-tg-nff-valuechanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}
    
    c-embarque:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage2.
    i-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage2.
    c-serie-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage2.
    c-estab-fisc:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage2.
    c-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage2.
    c-nat-operacao:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage2.
    c-ct-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage2.
    c-sc-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage2.

    ON 'ENTRY':U OF tt-impostos-despesa.cod-tax IN BROWSE brDigita DO:
        ASSIGN v-cod-tax-aux = input browse brDigita tt-impostos-despesa.cod-tax.
        RETURN "OK":U.
    END.

    ON 'LEAVE':U OF tt-impostos-despesa.cod-tax IN BROWSE brDigita DO:
        
        IF v-cod-tax-aux <> input browse brDigita tt-impostos-despesa.cod-tax 
            OR ( AVAIL tt-impostos-despesa AND v-cod-tax-aux <> tt-impostos-despesa.cod-tax )THEN DO:
            
            RUN findCh_tipo_tax IN h-bodi217 (INPUT  INPUT BROWSE brDigita tt-impostos-despesa.cod-tax,
                                              OUTPUT c-retorno).
            IF c-retorno = "" THEN DO:
                RUN getCharField IN h-bodi217 (INPUT  "descricao":U, OUTPUT c-descricao).
                RUN getDecField  IN h-bodi217 (INPUT  "tax-perc":U,  OUTPUT de-tax-perc).
                RUN getDecField  IN h-bodi217 (INPUT  "perc-percepcao":U,  OUTPUT de-perc-percepcao).
            END.
            ELSE
                ASSIGN c-descricao = ""
                       de-tax-perc = 0
                       de-perc-percepcao = 0.
    
            IF de-perc-percepcao <> 0 THEN DO:
                DISP c-descricao @ tt-impostos-despesa.descricao
                    de-perc-percepcao @ tt-impostos-despesa.tax-perc
                    WITH BROWSE brDigita.
            END.
            ELSE DO: 
                DISP c-descricao @ tt-impostos-despesa.descricao
                    de-tax-perc @ tt-impostos-despesa.tax-perc
                    WITH BROWSE brDigita.
            END.
            IF AVAIL tt-impostos-despesa THEN
                ASSIGN tt-impostos-despesa.l-automatico = FALSE
                       tt-impostos-despesa.vl-imposto    = 0
                       tt-impostos-despesa.vl-base       = 0
                       tt-impostos-despesa.vl-base-me    = 0
                       tt-impostos-despesa.vl-imposto-me = 0
                       tt-impostos-despesa.tax-perc      = input browse brDigita tt-impostos-despesa.tax-perc.
            
                RUN piCalculaBaseImposto.
            
        END.
        RETURN "OK":U.
    END.

    ON 'F5':U, 'MOUSE-SELECT-DBLCLICK':U OF tt-impostos-despesa.cod-tax IN BROWSE brDigita DO:
        {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                           &campo="tt-impostos-despesa.cod-tax"
                           &campozoom="cod-tax"
                           &BROWSE="brDigita"}
        APPLY "LEAVE":U TO tt-impostos-despesa.cod-tax IN BROWSE brDigita.
        RETURN "OK":U.
    END.
    ON 'LEAVE':U OF tt-impostos-despesa.tax-perc IN BROWSE brDigita DO:
        IF AVAIL tt-impostos-despesa THEN 
            ASSIGN tt-impostos-despesa.l-automatico = FALSE
                   tt-impostos-despesa.tax-perc = input browse brDigita tt-impostos-despesa.tax-perc.
        
        RUN piCalculaBaseImposto.
        
        RETURN "OK":U.
    END.
    ON 'LEAVE':U OF tt-impostos-despesa.vl-base-me IN BROWSE brDigita DO:
        IF AVAIL tt-impostos-despesa THEN
            ASSIGN tt-impostos-despesa.l-automatico  = FALSE
                   tt-impostos-despesa.vl-imposto    = 0
                   tt-impostos-despesa.vl-base       = 0
                   tt-impostos-despesa.vl-imposto-me = 0
                   tt-impostos-despesa.vl-base-me    = input browse brDigita tt-impostos-despesa.vl-base-me.
        
        RUN piCalculaBaseImposto.
        
        RETURN "OK":U.
    END.
    ON 'LEAVE':U OF tt-impostos-despesa.vl-imposto-me IN BROWSE brDigita DO:
        IF AVAIL tt-impostos-despesa THEN 
            ASSIGN tt-impostos-despesa.l-automatico  = FALSE
                   tt-impostos-despesa.vl-imposto-me = input browse brDigita tt-impostos-despesa.vl-imposto-me.
            
        RETURN "OK":U.
    END.

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

    RUN pi-inicializa-programas.
    RUN pi-inicializa-campos.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wReport 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-boin682) THEN DO:
        DELETE PROCEDURE h-boin682.
        ASSIGN h-boin682 = ?.
    END.

    IF  VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF  VALID-HANDLE(h-bodi217) THEN DO:
        DELETE PROCEDURE h-bodi217.
        ASSIGN h-bodi217 = ?.
    END.

    IF  VALID-HANDLE(h-bocx220h) THEN DO:
        DELETE PROCEDURE h-bocx220h.
        ASSIGN h-bocx220h = ?.
    END.

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN
        IF VALID-HANDLE(h-bopy2003) THEN
            RUN destroy IN h-bopy2003.

    IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO: /* API Finanáas -> handle Conta Cont†bil */
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.

    IF  VALID-HANDLE(h_api_ccusto) THEN DO:   /* API Finanáas -> handle Centro de Custo */
        DELETE PROCEDURE h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSelecaoEmbarque wReport 
PROCEDURE carregaTTSelecaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bocx220h) THEN DO:
        RUN carregaTtSelecaoEmbarque IN h-bocx220h (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fPage2,
                                                    INPUT 1, 
                                                    INPUT c-embarque:SCREEN-VALUE IN FRAME fPage2,   
                                                    INPUT c-embarque:SCREEN-VALUE IN FRAME fPage2,
                                                    INPUT 0,
                                                    INPUT 999999999,
                                                    INPUT NO,
                                                    INPUT &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,                       
                                                    INPUT 12/31/9999,                       
                                                    INPUT "",                               
                                                    INPUT "ZZZZZZZZZZZZZZZZZZZZ",           
                                                    INPUT "",                               
                                                    INPUT "ZZZZZZZZZZZZ",                   
                                                    INPUT "",                               
                                                    INPUT "ZZZZZZZZZZZZZZZZZZZZ",           
                                                    INPUT &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,                       
                                                    INPUT 12/31/9999,                       
                                                    INPUT 0,                                
                                                    INPUT 99999,                            
                                                    INPUT 0,                                
                                                    INPUT 999999999,                        
                                                    INPUT 0,                                
                                                    INPUT &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,                       
                                                    INPUT 12/31/9999,                       
                                                    INPUT "",                               
                                                    INPUT "ZZZZZZZZZZZZZZZZZZZZ",           
                                                    &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                                                        &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
                                                            INPUT "",                 
                                                            INPUT "ZZZZZZZZZZZZZZZZZZ",
                                                            INPUT "",                 
                                                            INPUT "ZZZZZZZZZZZZZZZZZZ",
                                                        &ENDIF
                                                    &ELSE
                                                        &IF '{&bf_mat_versao_ems}' >= '2.05' &THEN
                                                            INPUT "",                 
                                                            INPUT "ZZZZZZZZZZZZZZZZZZ",
                                                            INPUT "",                 
                                                            INPUT "ZZZZZZZZZZZZZZZZZZ",
                                                        &ELSE
                                                            INPUT "",
                                                            INPUT "ZZZZZZZZZZZZZZZZZZ",
                                                        &ENDIF
                                                    &ENDIF
                                                    OUTPUT TABLE tt-selecao-embarque). 
    END.
    
    FIND FIRST tt-selecao-embarque NO-ERROR.
    IF  AVAIL tt-selecao-embarque THEN
        ASSIGN tt-selecao-embarque.marca = "X":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-dados-embarque wReport 
PROCEDURE pi-busca-dados-embarque :
    DEFINE VARIABLE h-boin090a AS HANDLE NO-UNDO.
    DEFINE VARIABLE r-docum-est AS ROWID NO-UNDO.
    
    IF c-cod-estabel-aux  <> "" AND
       c-cod-emitente-aux <> "" AND 
       c-cod-estabel-aux  = c-cod-estabel:INPUT-VALUE IN FRAME fPage2  AND
       c-cod-emitente-aux = i-cod-emitente:INPUT-VALUE IN FRAME fPage2 THEN RETURN. 
    
    ASSIGN c-cod-estabel-aux  = c-cod-estabel:INPUT-VALUE IN FRAME fPage2
           c-cod-emitente-aux = i-cod-emitente:INPUT-VALUE IN FRAME fPage2.
    
    RUN inbo/boin090a.p PERSISTENT SET h-boin090a.
    RUN getUltimoDocumentoNotaComplementar IN h-boin090a(INPUT c-cod-estabel:INPUT-VALUE IN FRAME fPage2,
                                                         INPUT i-cod-emitente:INPUT-VALUE IN FRAME fPage2,
                                                         OUTPUT r-docum-est).
        
    IF r-docum-est <> ? THEN DO:
        FIND FIRST docum-est WHERE ROWID(docum-est) = r-docum-est NO-LOCK NO-ERROR.
        IF AVAILABLE(docum-est) THEN DO:
        
            ASSIGN INPUT FRAME fPage2 c-serie-docto:SCREEN-VALUE  = docum-est.serie-docto
                   INPUT FRAME fPage2 c-nat-operacao:SCREEN-VALUE = docum-est.nat-operacao
                   INPUT FRAME fPage2 c-estab-fisc:SCREEN-VALUE   = docum-est.estab-fisc
                   INPUT FRAME fPage2 c-ct-transit:SCREEN-VALUE   = docum-est.ct-transit
                   INPUT FRAME fPage2 c-sc-transit:SCREEN-VALUE   = docum-est.sc-transit.
        END.
    END.
    ELSE DO:    
        /* buscar as informaá‰es com base no embarque e no estabelecimento informados */
        /* Somente embarques nao encerrados */
        FOR EACH embarque-imp NO-LOCK USE-INDEX codigo
           WHERE embarque-imp.embarque    = c-embarque:SCREEN-VALUE IN FRAME fPage2
           AND   embarque-imp.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME fPage2:
            
            IF embarque-imp.situacao = 2 THEN NEXT. 
        
            FIND FIRST param-imp WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK NO-ERROR.
        
            IF NOT AVAIL param-imp THEN NEXT.
            
            FIND FIRST historico-embarque WHERE
                       historico-embarque.cod-estabel = embarque-imp.cod-estabel AND
                       historico-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
        
            IF NOT AVAIL historico-embarque THEN NEXT.
    
            FIND itinerario WHERE
                 itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.
        
            IF NOT AVAIL itinerario THEN NEXT.
            
            RELEASE historico-embarque.
            
            FIND historico-embarque WHERE
                 historico-embarque.cod-estabel   = embarque-imp.cod-estabel AND
                 historico-embarque.embarque      = embarque-imp.embarque    AND
                 historico-embarque.cod-itiner    = itinerario.cod-itiner    AND
                 historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar
                 USE-INDEX pto-contr NO-LOCK NO-ERROR.
            
            IF NOT AVAIL historico-embarque THEN NEXT.
    
            FIND FIRST ordens-embarque WHERE
                       ordens-embarque.cod-estabel = embarque-imp.cod-estabel AND
                       ordens-embarque.embarque    = embarque-imp.embarque    NO-LOCK NO-ERROR.
                 
            IF  AVAIL ordens-embarque THEN DO:
                FIND processo-imp WHERE
                     processo-imp.cod-estabel = ordens-embarque.cod-estabel AND
                     processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp 
                     NO-LOCK NO-ERROR.
                IF  AVAIL processo-imp THEN 
                    ASSIGN c-estab-fisc:SCREEN-VALUE IN FRAME fPage2 = processo-imp.estab-fisc.
                    
            END.
    
            assign c-ct-transit:SCREEN-VALUE IN FRAME fPage2 = param-imp.ct-transit-import
                   c-sc-transit:SCREEN-VALUE IN FRAME fPage2 = param-imp.sc-transit-import.
        end.
    END.
    
    return "OK":U.
    
    FINALLY:
        IF VALID-HANDLE(h-boin090a) THEN
            DELETE PROCEDURE h-boin090a.                  
    END FINALLY.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos wReport 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    ASSIGN c-empresa = param-global.empresa-prin.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        ASSIGN cLista = {ininc/i03in090.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cLista).
        ASSIGN cb-cod-observa:LIST-ITEM-PAIRS IN FRAME fPage2 = cLista.
    &else
        ASSIGN cb-cod-observa:LIST-ITEMS IN FRAME fPage2 = {ininc/i03in090.i 03}.
    &endif
    
    ASSIGN c-embarque:SCREEN-VALUE       IN FRAME fPage2 = ""
           i-cod-emitente:SCREEN-VALUE   IN FRAME fPage2 = "0"
           c-serie-docto:SCREEN-VALUE    IN FRAME fPage2 = ""
           c-estab-fisc:SCREEN-VALUE     IN FRAME fPage2 = ""
           c-cod-estabel:SCREEN-VALUE    IN FRAME fPage2 = ""
           c-nro-docto:SCREEN-VALUE      IN FRAME fPage2 = ""
           c-nat-operacao:SCREEN-VALUE   IN FRAME fPage2 = ""
           c-ct-transit:SCREEN-VALUE     IN FRAME fPage2 = ""
           c-sc-transit:SCREEN-VALUE     IN FRAME fPage2 = ""
           tg-nff:CHECKED                IN FRAME fPage2 = NO
           c-observacao:SCREEN-VALUE     IN FRAME fPage2 = ""
           cb-cod-observa:SCREEN-VALUE   IN FRAME fPage2 = entry(2,cb-cod-observa:LIST-ITEM-PAIRS IN FRAME fPage2,",")
           da-dt-trans:SCREEN-VALUE      IN FRAME fPage2 = STRING(TODAY)
           da-dt-cotacao:SCREEN-VALUE    IN FRAME fPage2 = STRING(TODAY)
           da-dt-emissao:SCREEN-VALUE    IN FRAME fPage2 = STRING(TODAY)
           i-cod-desp-ini                                = 0
           i-cod-desp-fim                                = 99999
           i-fornec-desp-ini                             = 0
           i-fornec-desp-fim                             = 999999999
           i-pto-controle-ini                            = 0
           i-pto-controle-fim                            = 99999
           tg-atualiz-receb-auto:CHECKED IN FRAME fPage2 = NO                          .

    IF  NOT AVAIL param-estoq THEN
        FOR FIRST param-estoq NO-LOCK: END.

    /*Quando tem valor na param-estoq deve ser considerado o que est† nesse campo e n∆o na param-global*/
    IF  SUBSTRING(param-estoq.char-2,68,1) <> "" THEN
        ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S").
    ELSE DO:
        {cdp/cd4300.i4  "yes" param-global.char-2}
        {cdp/cd0101.i51 "yes"}
    END.

    IF  NOT l-ut-ser  /* n∆o utiliza serie */
        AND i-pais-impto-usuario <> 1 /* Brasil */ THEN
        ASSIGN c-serie-docto:HIDDEN       IN FRAME fPage2 = YES
               c-serie-docto:SCREEN-VALUE IN FRAME fPage2 = SUBSTRING(param-estoq.char-2,69,5).            

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
        
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            ASSIGN cLista = {local/pry/py2inc/i00py2008.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cLista).
            ASSIGN cb-tipo-comprov:LIST-ITEM-PAIRS IN FRAME fPage2 = cLista
                   cb-tipo-comprov:SCREEN-VALUE IN FRAME fPage2 = ENTRY(2, cLista). /* Pega o primeiro VALUE */
        &else
            ASSIGN cb-tipo-comprov:LIST-ITEMS IN FRAME fPage2 = {ininc/i03in090.i 03}
                   cb-tipo-comprov:SCREEN-VALUE IN FRAME fPage2 = ENTRY(1, cb-tipo-comprov:LIST-ITEMS IN FRAME fPage2).
        &endif
    
        ASSIGN c-nro-docto:FORMAT IN FRAME fPage2  = "x(7)"
               f-timbrado:HIDDEN IN FRAME fPage2  = NO
               f-dt-vto:HIDDEN IN FRAME fPage2    = NO
               f-estab-fat:HIDDEN IN FRAME fPage2 = NO
               f-pto-vda:HIDDEN IN FRAME fPage2   = NO
               f-timbrado:SCREEN-VALUE IN FRAME fPage2  = "0"
               f-dt-vto:SCREEN-VALUE IN FRAME fPage2    = ""
               f-estab-fat:SCREEN-VALUE IN FRAME fPage2 = "000"
               f-pto-vda:SCREEN-VALUE IN FRAME fPage2   = "000"
               tg-nff:CHECKED in frame fPage2     = YES
               tg-nff:sensitive in frame fPage2   = NO. 
    END.
    ELSE DO:
        ASSIGN f-timbrado:HIDDEN IN FRAME fPage2  = YES
               f-dt-vto:HIDDEN IN FRAME fPage2    = YES
               f-estab-fat:HIDDEN IN FRAME fPage2 = YES
               f-pto-vda:HIDDEN IN FRAME fPage2   = YES
               tg-nff:sensitive in frame fPage2   = YES
               cb-tipo-comprov:HIDDEN IN FRAME fPage2 = YES.
    
        IF i-pais-impto-usuario = 2 /* ARG */ THEN DO:
            ASSIGN fi-d-val-gravad:HIDDEN IN FRAME fPage2     = FALSE
                   fi-d-val-nao-gravad:HIDDEN IN FRAME fPage2 = FALSE 
                   fi-d-val-isento:HIDDEN IN FRAME fPage2     = FALSE.

            APPLY "value-changed":U TO tg-nff IN FRAME fPage2.

        END.
    END.
    
    IF  i-pais-impto-usuario = 21 THEN DO:
        ASSIGN c-serie-docto:HIDDEN IN FRAME fPage2 = YES.
        IF SUBSTRING(param-estoq.char-2,68,1) = "N" THEN   
            ASSIGN c-serie-docto:HIDDEN IN FRAME fPage2 = YES
                   c-serie-docto = SUBSTRING(param-estoq.char-2,69,5). 

        ASSIGN i-cdn-pto-emis   :SCREEN-VALUE IN FRAME fPage4 = "000"
               c-cod-estabel-ats:SCREEN-VALUE IN FRAME fPage4 = ""
               d-dat-autoriz    :SCREEN-VALUE IN FRAME fPage4 = ?
               c-num-autoriz-sri:SCREEN-VALUE IN FRAME fPage4 = "".
    END.
    ELSE DO:
        IF l-abert-prog THEN
            RUN deleteFolder IN hFolder(2).        
    END.
    
    assign c-embarque:sensitive    in frame fPage2 = YES
           c-cod-estabel:sensitive in frame fPage2 = YES
           l-abert-prog = NO.

    RUN piCotacaoMoeda.       
           
    {&OPEN-QUERY-brDigita}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-programas wReport 
PROCEDURE pi-inicializa-programas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-boin682) THEN DO:
        RUN inbo/boin682.p PERSISTENT SET h-boin682.
        RUN openQueryStatic IN h-boin682 (INPUT "Main":U).
    END.

    IF NOT VALID-HANDLE(h-boad098) THEN DO:
        RUN adbo/boad098.p PERSISTENT SET h-boad098.
    END.

    IF NOT VALID-HANDLE(h-bodi217) THEN DO:
        RUN dibo/bodi217.p PERSISTENT SET h-bodi217.
    END.

    IF NOT VALID-HANDLE(h-bocx220h) THEN DO:
        RUN cxbo/bocx220h.p PERSISTENT SET h-bocx220h.
    END.

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  NOT VALID-HANDLE(h-boar2134) THEN
            RUN local/arg/boar2134.p PERSISTENT SET h-boar2134.
    END.

    IF  i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
        IF  NOT VALID-HANDLE(h-bopy2003) THEN
            RUN local/pry/bopy2003.p PERSISTENT SET h-bopy2003.
    END.

    IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    IF  NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-conta-trans wReport 
PROCEDURE pi-mostra-conta-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-return        AS CHARACTER   NO-UNDO.

    APPLY "LEAVE":U TO c-cod-estabel IN FRAME fPage2.

    IF NOT VALID-HANDLE(h-bocx250) THEN
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.

    EMPTY TEMP-TABLE tt-param-imp.

    RUN findCodigo IN h-bocx250 (INPUT INPUT FRAME fPage2 c-cod-estabel,
                                 OUTPUT c-return).

    IF c-return = "":U THEN
        RUN GetCurrent IN h-bocx250 (OUTPUT TABLE tt-param-imp).

    FOR FIRST tt-param-imp:
        ASSIGN c-ct-transit = tt-param-imp.ct-transit-import
               c-sc-transit = tt-param-imp.sc-transit-import.
    END.

    DISP c-ct-transit c-sc-transit WITH FRAME fPage2.

    APPLY "LEAVE":U TO c-ct-transit IN FRAME fPage2.

    DELETE PROCEDURE h-bocx250.
    ASSIGN h-bocx250 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tg-nff-valuechanged wReport 
PROCEDURE pi-tg-nff-valuechanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-pais-impto-usuario = 2 /* ARG */ THEN DO:
        ASSIGN 
            fi-d-val-gravad:SCREEN-VALUE IN FRAME fPage2     = "0.00"
            fi-d-val-nao-gravad:SCREEN-VALUE IN FRAME fPage2 = "0.00"
            fi-d-val-isento:SCREEN-VALUE IN FRAME fPage2     = "0.00".
        
        IF NOT INPUT FRAME fPage2 tg-nff THEN
            ASSIGN
                fi-d-val-gravad:sensitive in frame fPage2        = NO
                fi-d-val-nao-gravad:sensitive in frame fPage2    = NO
                fi-d-val-isento:sensitive in frame fPage2        = NO.
        ELSE 
            ASSIGN
                fi-d-val-gravad:sensitive in frame fPage2        = YES
                fi-d-val-nao-gravad:sensitive in frame fPage2    = YES
                fi-d-val-isento:sensitive in frame fPage2        = YES.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaBaseImposto wReport 
PROCEDURE piCalculaBaseImposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-vl-base-me    LIKE tt-impostos-despesa.vl-base-me     NO-UNDO.
    DEFINE VARIABLE v-vl-imposto-me LIKE tt-impostos-despesa.vl-imposto-me  NO-UNDO.
    DEFINE VARIABLE v-tax-perc      LIKE tt-impostos-despesa.tax-perc       NO-UNDO.

    IF  NOT AVAIL tt-impostos-despesa THEN
        RETURN.
    
    ASSIGN v-vl-base-me    = INPUT BROWSE brDigita tt-impostos-despesa.vl-base-me   
           v-vl-imposto-me = INPUT BROWSE brDigita tt-impostos-despesa.vl-imposto-me
           v-tax-perc      = INPUT BROWSE brDigita tt-impostos-despesa.tax-perc.     
    
    IF i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  NOT VALID-HANDLE (h-arg0020a) THEN
            run local/arg/arg0020a.p  persistent set h-arg0020a.
    
        RUN piCalculaBaseImposto IN h-arg0020a (INPUT INPUT BROWSE brDigita tt-impostos-despesa.cod-tax,
                                                INPUT-OUTPUT v-tax-perc,
                                                INPUT INPUT FRAME fPage2 fi-d-val-gravad,
                                                INPUT INPUT FRAME fPage2 fi-d-val-isento,
                                                INPUT-OUTPUT v-vl-base-me,
                                                OUTPUT v-vl-imposto-me).
        IF  VALID-HANDLE (h-arg0020a) THEN DO:
            DELETE PROCEDURE h-arg0020a.    
            ASSIGN h-arg0020a = ?.
        END.
    END.
    ELSE DO:
        IF  NOT VALID-HANDLE (h-im3101a) THEN
            run imp/im3101a.p  persistent set h-im3101a.

        IF v-vl-base-me = 0 THEN DO:
            FOR EACH tt-desp-embarque NO-LOCK WHERE tt-desp-embarque.selecionado:
                ASSIGN v-vl-base-me = v-vl-base-me + tt-desp-embarque.val-desp.
            END.

            RUN piCalculaBaseRetencaoIVA IN h-im3101a (INPUT TABLE tt-impostos-despesa,
                                                       INPUT INPUT BROWSE brDigita tt-impostos-despesa.cod-tax,
                                                       INPUT-OUTPUT v-vl-base-me).
        END.

        RUN piCalculaImposto IN h-im3101a (INPUT INPUT BROWSE brDigita tt-impostos-despesa.cod-tax,
                                           INPUT-OUTPUT v-tax-perc,
                                           INPUT  v-vl-base-me,
                                           OUTPUT v-vl-imposto-me).
        IF  VALID-HANDLE (h-im3101a) THEN DO:
            DELETE PROCEDURE h-im3101a.    
            ASSIGN h-im3101a = ?.
        END.        
    END.

    DISP v-tax-perc      @ tt-impostos-despesa.tax-perc
         v-vl-base-me    @ tt-impostos-despesa.vl-base-me
         v-vl-imposto-me @ tt-impostos-despesa.vl-imposto-me
         WITH BROWSE brDigita.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaImpostoARG wReport 
PROCEDURE piCalculaImpostoARG :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-imposto.
    
    IF TEMP-TABLE tt-desp-embarque:HAS-RECORDS THEN DO:
        FOR EACH tt-impostos-despesa 
            WHERE tt-impostos-despesa.l-automatico:
            DELETE tt-impostos-despesa.
        END.

        IF NOT VALID-HANDLE (h-arg0020a) THEN
            run local/arg/arg0020a.p  persistent set h-arg0020a.
        
        RUN piCalculaImpostoComplementarArg IN h-arg0020a (INPUT INPUT FRAME fPage2 i-cod-emitente,
                                                           INPUT INPUT FRAME fPage2 c-cod-estabel, 
                                                           INPUT INPUT FRAME fPage2 fi-d-val-gravad,
                                                           INPUT INPUT FRAME fPage2 fi-d-val-isento,
                                                           input INPUT FRAME fPage2 da-dt-cotacao,
                                                           input INPUT FRAME fPage2 c-nat-operacao,
                                                           INPUT INPUT FRAME fPage2 d-cotacao,
                                                           INPUT TABLE tt-desp-embarque,
                                                           input-output table tt-imposto).

        FOR EACH tt-imposto:
            FIND FIRST tt-impostos-despesa 
                WHERE tt-impostos-despesa.cod-tax = tt-imposto.cod-imposto NO-ERROR.
            IF NOT AVAIL tt-impostos-despesa THEN DO:
                CREATE tt-impostos-despesa.
                ASSIGN tt-impostos-despesa.cod-tax       = tt-imposto.cod-imposto
                       tt-impostos-despesa.descricao     = tt-imposto.desc-imposto
                       tt-impostos-despesa.tax-perc      = tt-imposto.perc-percepcao
                       tt-impostos-despesa.vl-base       = tt-imposto.vl-base
                       tt-impostos-despesa.vl-imposto    = tt-imposto.vl-percepcao
                       tt-impostos-despesa.vl-base-me    = tt-imposto.vl-base-me
                       tt-impostos-despesa.vl-imposto-me = tt-imposto.vl-percepcao-me
                       tt-impostos-despesa.l-automatico  = YES.
            END.
        END.
        
        IF  VALID-HANDLE (h-arg0020a) THEN DO:
            DELETE PROCEDURE h-arg0020a.    
            ASSIGN h-arg0020a = ?.
        END.
    END.
    {&OPEN-QUERY-brDigita}
    IF TEMP-TABLE tt-impostos-despesa:HAS-RECORDS THEN
        assign btDelete:SENSITIVE in frame fPage5 = yes.

    RETURN "OK":U.
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

    define var r-tt-impostos-despesa as rowid  no-undo.    
    DEF VAR h-boar2016 AS HANDLE NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
        EMPTY TEMP-TABLE tt-parametros.
    
        /***** VALIDAÄÂES PASTA IMPOSTOS *****/
        FOR EACH tt-impostos-despesa NO-LOCK:
            ASSIGN r-tt-impostos-despesa = ROWID(tt-impostos-despesa).
            
            /*:T Validaá∆o de duplicidade de registro na temp-table tt-impostos-despesa */
            FIND FIRST b-tt-impostos-despesa NO-LOCK
                WHERE b-tt-impostos-despesa.cod-tax = tt-impostos-despesa.cod-tax 
                  AND ROWID(b-tt-impostos-despesa) <> ROWID(tt-impostos-despesa) NO-ERROR.
            IF  AVAIL b-tt-impostos-despesa THEN DO:
                REPOSITION brDigita TO ROWID ROWID(b-tt-impostos-despesa).
                {utp/ut-liter.i O_Imposto *}
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 30747, 
                                   INPUT RETURN-VALUE + "~~":U + RETURN-VALUE  + " " +  string(tt-impostos-despesa.cod-tax)).
                APPLY "ENTRY":U TO tt-impostos-despesa.cod-tax IN BROWSE brDigita.
                RETURN ERROR.
            END.
    
            IF VALID-HANDLE(h-bodi217) AND (AVAIL tt-impostos-despesa AND tt-impostos-despesa.cod-tax <> 0)THEN DO:
                RUN findCh_tipo_tax IN h-bodi217 (INPUT  tt-impostos-despesa.cod-tax,
                                                  OUTPUT c-retorno).
                IF c-retorno <> "" THEN DO:
                    ASSIGN BROWSE brDigita:CURRENT-COLUMN = tt-impostos-despesa.cod-tax:HANDLE IN BROWSE brDigita.
                    REPOSITION brDigita to rowid r-tt-impostos-despesa.
    
                    {utp/ut-liter.i Imposto *}
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                       INPUT 2, 
                                       INPUT RETURN-VALUE).
                    APPLY "ENTRY":U TO tt-impostos-despesa.cod-tax IN BROWSE brDigita.
                    RETURN ERROR.
                END.
            END.
        end.
        /*************************************/
        IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
        
            ASSIGN c-cb-tipo-comprov-aux = INPUT FRAME fPage2 cb-tipo-comprov.
            
            RUN pi-valida-campos IN h-bopy2003 (INPUT INPUT FRAME fPage2 c-nro-docto,
                                                INPUT INPUT FRAME fPage2 i-cod-emitente,
                                                INPUT INPUT FRAME fPage2 da-dt-emissao,
                                                INPUT INPUT FRAME fPage2 f-timbrado,
                                                INPUT INPUT FRAME fPage2 f-dt-vto,
                                                INPUT INPUT FRAME fPage2 f-estab-fat,
                                                INPUT INPUT FRAME fPage2 f-pto-vda,
                                                INPUT {local/pry/py2inc/i00py2008.i 06 c-cb-tipo-comprov-aux},
                                                OUTPUT TABLE tt-bo-erro). 
    
            IF  CAN-FIND(FIRST tt-bo-erro) THEN DO:
                IF NOT VALID-HANDLE(hShowMsg) THEN
                    run utp/showmessage.w PERSISTENT SET hShowMsg.
                ELSE DO:
                    DELETE PROCEDURE hShowMsg.
                    run utp/showmessage.w PERSISTENT SET hShowMsg.
                END.
                RUN setModal     IN hShowMsg (INPUT YES).
                run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
                RETURN "NOK":U.
            END.
                
        END.

        IF  NOT VALID-HANDLE(h-im3101a) THEN 
            RUN imp/im3101a.p PERSISTENT SET h-im3101a.
             
        IF  NOT CAN-FIND(FIRST  tt-selecao-embarque
                         WHERE tt-selecao-embarque.marca = "X") THEN DO:

            RUN CarregaTTSelecaoEmbarque IN THIS-PROCEDURE.
            IF  NOT CAN-FIND (FIRST tt-selecao-embarque) THEN DO:
                CREATE tt-selecao-embarque.
                ASSIGN tt-selecao-embarque.embarque    = INPUT FRAME fPage2 c-embarque
                       tt-selecao-embarque.cod-estabel = INPUT FRAME fPage2 c-cod-estabel
                       tt-selecao-embarque.marca       = "X":U
                       l-embarque-invalido             = YES.
            END.
        END.

        FOR EACH  tt-selecao-embarque
            WHERE tt-selecao-embarque.marca = "X":U:
    
            CREATE tt-parametros.
            ASSIGN tt-parametros.embarque             = tt-selecao-embarque.embarque
                   tt-parametros.cod-emitente-desp    = INPUT FRAME fPage2 i-cod-emitente
                   tt-parametros.serie                = IF i-pais-impto-usuario = 21 THEN c-serie-docto ELSE INPUT FRAME fPage2 c-serie-docto
                   tt-parametros.da-transacao         = INPUT FRAME fPage2 da-dt-trans
                   tt-parametros.estab-fisc           = INPUT FRAME fPage2 c-estab-fisc
                   tt-parametros.da-cotacao           = INPUT FRAME fPage2 da-dt-cotacao
                   tt-parametros.nff                  = INPUT FRAME fPage2 tg-nff
                   tt-parametros.observacao           = INPUT FRAME fPage2 c-observacao
                   tt-parametros.cod-estabel          = tt-selecao-embarque.cod-estabel 
                   tt-parametros.nro-docto            = INPUT FRAME fPage2 c-nro-docto
                   tt-parametros.nat-operacao         = INPUT FRAME fPage2 c-nat-operacao
                   tt-parametros.da-emissao           = INPUT FRAME fPage2 da-dt-emissao
                   tt-parametros.ct-transit           = INPUT FRAME fPage2 c-ct-transit
                   tt-parametros.sc-transit           = INPUT FRAME fPage2 c-sc-transit
                   tt-parametros.usuario              = c-seg-usuario
                   tt-parametros.l-acomp              = YES 
                   tt-parametros.i-pais-impto-usuario = i-pais-impto-usuario
                   tt-parametros.d-cotacao            = INPUT FRAME fPage2 d-cotacao.

            IF i-pais-impto-usuario = 21 THEN DO:
                ASSIGN tt-parametros.cdn-pto-emis     = INPUT FRAME fPage4 i-cdn-pto-emis        
                       tt-parametros.cod-estabel-ats  = INPUT FRAME fPage4 c-cod-estabel-ats         
                       tt-parametros.dat-autoriz      = INPUT FRAME fPage4 d-dat-autoriz         
                       tt-parametros.cod-autoriz-sri  = INPUT FRAME fPage4 c-num-autoriz-sri
                       tt-parametros.l-reembol        = NO /* retirada a opá∆o de reembolso nessa tela*/ .
            END.
            
            IF LOOKUP(cb-cod-observa:SCREEN-VALUE,cb-cod-observa:LIST-ITEM-PAIRS IN FRAME fPage2,",") MOD 2 <> 0 THEN 
                ASSIGN tt-parametros.cod-observacao = (LOOKUP(cb-cod-observa:SCREEN-VALUE,cb-cod-observa:LIST-ITEM-PAIRS IN FRAME fPage2,",") + 1) / 2.
            ELSE  
                ASSIGN tt-parametros.cod-observacao = LOOKUP(cb-cod-observa:SCREEN-VALUE,cb-cod-observa:LIST-ITEM-PAIRS IN FRAME fPage2,",") / 2.
        END.

        IF  l-embarque-invalido THEN
            EMPTY TEMP-TABLE tt-selecao-embarque.
            
        IF  CAN-FIND(FIRST tt-desp-embarque) THEN DO:
            FOR EACH tt-desp-embarque:

                IF NOT CAN-FIND(FIRST tt-selecao-embarque
                                WHERE tt-selecao-embarque.cod-estabel = tt-desp-embarque.cod-estabel
                                  AND tt-selecao-embarque.embarque    = tt-desp-embarque.embarque
                                  AND tt-selecao-embarque.marca       = "X":U)
                    OR NOT tt-desp-embarque.selecionado THEN
                    DELETE tt-desp-embarque.
            END.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 34477,
                               INPUT "").
            
            APPLY "entry":U TO c-embarque IN FRAME fPage2.
            RETURN NO-APPLY.
        END.

        IF d-cotacao:INPUT-VALUE IN FRAME fPage2 = 0 THEN DO:
            {utp/ut-liter.i "Cotaá∆o Moeda" *}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 7965,
                               INPUT TRIM(RETURN-VALUE)). /* &1 deve ser diferente de 0. */
                               
            IF d-cotacao:SENSITIVE IN FRAME fPage2 = YES THEN
                APPLY "ENTRY":U TO d-cotacao IN FRAME fPage2.
                
            RETURN NO-APPLY.
        END.
        
        IF i-pais-impto-usuario = 2 THEN DO:
            RUN valorGravadoNaoGravadoIsento IN h-im3101a (INPUT INPUT FRAME fPage2 fi-d-val-gravad,
                                                           INPUT INPUT FRAME fPage2 fi-d-val-nao-gravad,
                                                           INPUT INPUT FRAME fPage2 fi-d-val-isento).
        END.

        FIND FIRST tt-desp-embarque NO-LOCK NO-ERROR.
        IF AVAIL tt-desp-embarque THEN DO:
            FOR EACH tt-impostos-despesa
                WHERE NOT tt-impostos-despesa.l-automatico:
    
                RUN cdp/cd0812a.p (INPUT  tt-desp-embarque.moeda,
                                   INPUT  0,
                                   INPUT  tt-impostos-despesa.vl-imposto-me,
                                   INPUT  INPUT FRAME fPage2 d-cotacao,
                                   OUTPUT tt-impostos-despesa.vl-imposto).
                RUN cdp/cd0812a.p (INPUT  tt-desp-embarque.moeda,
                                   INPUT  0,
                                   INPUT  tt-impostos-despesa.vl-base-me,
                                   INPUT  INPUT FRAME fPage2 d-cotacao,
                                   OUTPUT tt-impostos-despesa.vl-base).
            END.
        END.        

        RUN setTtSelecao IN h-im3101a (INPUT TABLE tt-desp-embarque,
                                       INPUT TABLE tt-impostos-despesa).
        
        RUN createNFComplementar IN h-im3101a (INPUT  TABLE tt-parametros,
                                               OUTPUT TABLE tt-docum-est,
                                               OUTPUT TABLE RowErrors).

        IF  VALID-HANDLE (h-im3101a) THEN DO:
            DELETE PROCEDURE h-im3101a.    
            ASSIGN h-im3101a = ?.
        END.

        IF i-pais-impto-usuario = 2 THEN DO:    
            
            FIND FIRST docum-est
                     WHERE docum-est.serie-docto  = INPUT FRAME fPage2 c-serie-docto   
                       AND docum-est.nro-docto    = INPUT FRAME fPage2 c-nro-docto 
                       AND docum-est.cod-emitente = INPUT FRAME fPage2 i-cod-emitente
                       AND docum-est.nat-operacao = INPUT FRAME fPage2 c-nat-operacao NO-LOCK NO-ERROR.
            if  avail docum-est then do:
                IF  l-executar 
                AND INPUT FRAME fPage2 tg-nff = YES THEN DO:

                    IF  CAN-FIND(FIRST emitente 
                                 WHERE emitente.cod-emitente = docum-est.cod-emitente
                                   AND emitente.natureza    <> 3 /* Estrangeiro */) THEN DO:                            
                        RUN local/arg/arg0034.w (INPUT rowid(docum-est),
                                                 INPUT INPUT FRAME fPage2 fi-d-val-gravad,
                                                 INPUT INPUT FRAME fPage2 fi-d-val-nao-gravad,
                                                 INPUT INPUT FRAME fPage2 fi-d-val-isento).
                        IF RETURN-VALUE = "NOK":U THEN DO:
                            RETURN ERROR.
                        END.
                    END.
                    ELSE DO:
                        /* Salva informaá‰es para fornecedor estrangeiro */
                        RUN local/arg/boar2016.p PERSISTENT SET h-boar2016.
                        RUN pi-salva-info-rateio IN h-boar2016 (INPUT ROWID(docum-est),
                                                                INPUT INPUT FRAME fPage2 fi-d-val-gravad,
                                                                INPUT INPUT FRAME fPage2 fi-d-val-nao-gravad,
                                                                INPUT INPUT FRAME fPage2 fi-d-val-isento).
                        RUN destroy IN h-boar2016.
                        IF  RETURN-VALUE = "NOK":U THEN
                            RETURN ERROR.
                    END.
                END.
            END.
        END.
        
        IF  NOT l-executar THEN DO:
            FIND FIRST RowErrors
                 WHERE RowErrors.ErrorNumber = 27207 NO-ERROR.
            IF  AVAIL RowErrors THEN
                DELETE RowErrors.
        END.
        
        IF  CAN-FIND(FIRST RowErrors 
                     WHERE RowErrors.ErrorSubtype <> "ERROR":U) 
        AND RETURN-VALUE = "OK":U THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
        END.

        IF  CAN-FIND(FIRST RowErrors 
                     WHERE RowErrors.ErrorSubtype <> "INFORMATION":U) 
        AND RETURN-VALUE = "OK":U THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
        END.

        IF  CAN-FIND(FIRST RowErrors) AND RETURN-VALUE = "NOK":U THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
            RETURN "NOK":U.
        END.
    END.
               
    /** RELATORIO **/
    IF  NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubtype = "ERROR":U) THEN DO:

        IF l-executar THEN DO:
            IF i-pais-impto-usuario = 9 /* Paraguai */ OR i-pais-impto-usuario = 2 THEN DO:
                FIND FIRST docum-est
                     WHERE docum-est.serie-docto  = INPUT FRAME fPage2 c-serie-docto   
                       AND docum-est.nro-docto    = INPUT FRAME fPage2 c-nro-docto 
                       AND docum-est.cod-emitente = INPUT FRAME fPage2 i-cod-emitente
                       AND docum-est.nat-operacao = INPUT FRAME fPage2 c-nat-operacao NO-LOCK NO-ERROR.

                IF AVAIL docum-est THEN DO:
                    IF i-pais-impto-usuario = 9 THEN DO:
                    
                        RUN pi-atualiza-campos IN h-bopy2003 (INPUT i-ep-codigo-usuario,
                                                              INPUT docum-est.serie-docto,
                                                              INPUT docum-est.nro-docto, 
                                                              INPUT docum-est.cod-emitente, 
                                                              INPUT docum-est.nat-operacao, 
                                                              INPUT INPUT FRAME fPage2 f-timbrado,
                                                              INPUT INPUT FRAME fPage2 f-dt-vto,
                                                              INPUT INPUT FRAME fPage2 f-estab-fat,
                                                              INPUT INPUT FRAME fPage2 f-pto-vda,
                                                              INPUT INT(INPUT FRAME fPage2 c-nro-docto),
                                                              INPUT 0,
                                                              INPUT 0,
                                                              INPUT {local/pry/py2inc/i00py2008.i 06 c-cb-tipo-comprov-aux},
                                                              INPUT "":U).
                    END.
                END.
            END.
        END.
         
        /* Recebimento Autom†tico */ 
        IF tg-atualiz-receb-auto:screen-value in frame fPage2  = "YES" AND l-executar THEN DO:
        
            EMPTY TEMP-TABLE tt-digita.
            EMPTY TEMP-TABLE tt-param.
        
            FIND FIRST docum-est
                 WHERE docum-est.serie-docto  = INPUT FRAME fPage2 c-serie-docto   
                   AND docum-est.nro-docto    = INPUT FRAME fPage2 c-nro-docto 
                   AND docum-est.cod-emitente = INPUT FRAME fPage2 i-cod-emitente
                   AND docum-est.nat-operacao = INPUT FRAME fPage2 c-nat-operacao NO-LOCK NO-ERROR.
            IF AVAIL docum-est THEN DO:
            
                CREATE tt-digita.
                ASSIGN tt-digita.r-docum-est = rowid(docum-est).
                    
                CREATE tt-param.
                ASSIGN tt-param.usuario         = c-seg-usuario
                       tt-param.destino         = 3
                       tt-param.data-exec       = TODAY 
                       tt-param.hora-exec       = TIME 
                       tt-param.arquivo         = (SESSION:TEMP-DIRECTORY + "RE1005":U + ".tmp"). 
                       
                RAW-TRANSFER tt-param TO raw-param.

                EMPTY TEMP-TABLE tt-raw-digita.
                FOR EACH tt-digita:
                    CREATE tt-raw-digita.
                    RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
                END.                                
                
                RUN rep/re1005rp.p (INPUT raw-param, INPUT TABLE tt-raw-digita).
                
                &SCOPED-DEFINE PDF NO
                {include/i-rptrm.i}
                
            END.
        END. 
        ELSE DO:
            RUN imp/im3101rp.p (INPUT TABLE tt-parametros,
                                INPUT TABLE tt-selecao-embarque,
                                INPUT TABLE tt-desp-embarque,      
                                INPUT TABLE tt-docum-est,             
                                INPUT c-embarque-anterior,
                                INPUT l-executar). 
        END.
        
        IF l-executar THEN DO:
            EMPTY TEMP-TABLE tt-selecao-embarque.
            EMPTY TEMP-TABLE tt-desp-embarque.
            EMPTY TEMP-TABLE tt-desp-embarque-aux.
            EMPTY TEMP-TABLE tt-impostos-despesa.
            EMPTY TEMP-TABLE tt-impostos.

            RUN pi-inicializa-campos.
        END.
    END.
    /*************************************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCotacaoMoeda wReport 
PROCEDURE piCotacaoMoeda:
/*------------------------------------------------------------------------------
  Purpose: Controle do campo Cotaá∆o Moeda no IM3101
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST b-tt-desp-embarque NO-LOCK
         WHERE b-tt-desp-embarque.selecionado = YES NO-ERROR.
    IF NOT AVAIL b-tt-desp-embarque THEN DO:
        ASSIGN d-cotacao:SCREEN-VALUE IN FRAME fPage2 = "0"
               d-cotacao:SENSITIVE    IN FRAME fPage2 = NO.
    END.
    ELSE DO:
        IF b-tt-desp-embarque.moeda = 0 THEN DO:
            ASSIGN d-cotacao:SCREEN-VALUE IN FRAME fPage2 = "1"
                   d-cotacao:SENSITIVE    IN FRAME fPage2 = NO.    
        END.
        ELSE DO:
            FIND FIRST cotacao NO-LOCK
                 WHERE cotacao.mo-codigo   = b-tt-desp-embarque.moeda
                   AND cotacao.ano-periodo = STRING(YEAR(da-dt-cotacao:INPUT-VALUE IN FRAME fPage2)) + STRING(MONTH(da-dt-cotacao:INPUT-VALUE IN FRAME fPage2),"99")
                   AND cotacao.cotacao[INT(DAY(da-dt-cotacao:INPUT-VALUE IN FRAME fPage2))] <> 0 NO-ERROR.
        
            ASSIGN d-cotacao:SCREEN-VALUE IN FRAME fPage2 = STRING(IF AVAIL cotacao THEN cotacao.cotacao[INT(DAY(da-dt-cotacao:INPUT-VALUE IN FRAME fPage2))] ELSE 1).
                   d-cotacao:SENSITIVE    IN FRAME fPage2 = YES.    
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaEmbarque wReport 
PROCEDURE piSetaEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Seta embarque IM3101
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-embarque AS CHARACTER NO-UNDO.
    
    ASSIGN c-embarque:SCREEN-VALUE IN FRAME fPage2 = p-embarque.
    
    APPLY "LEAVE":U TO c-embarque    IN FRAME fPage2.
    APPLY "ENTRY":U TO c-cod-estabel IN FRAME fPage2.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaEstabelecimento wReport 
PROCEDURE piSetaEstabelecimento:
/*------------------------------------------------------------------------------
  Purpose: Seta estabelecimento IM3101
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    
    ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fPage2 = p-cod-estabel.
    
    APPLY "LEAVE":U TO c-cod-estabel  IN FRAME fPage2.
    APPLY "ENTRY":U TO i-cod-emitente IN FRAME fPage2.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaEmitente wReport 
PROCEDURE piSetaEmitente:
/*------------------------------------------------------------------------------
  Purpose: Seta emitente IM3101
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER NO-UNDO.
    
    ASSIGN i-cod-emitente:SCREEN-VALUE IN FRAME fPage2 = STRING(p-cod-emitente).
    
    APPLY "LEAVE":U TO i-cod-emitente IN FRAME fPage2.
    APPLY "ENTRY":U TO c-nro-docto    IN FRAME fPage2.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaDespesa wReport 
PROCEDURE piSetaDespesa:
/*------------------------------------------------------------------------------
  Purpose: Seta despesa IM3101
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER TABLE FOR tt-desp-embarque.
    DEFINE INPUT PARAMETER TABLE FOR tt-desp-embarque-aux.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
