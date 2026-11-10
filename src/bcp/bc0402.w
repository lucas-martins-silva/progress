&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0402 2.00.00.029}  /*** "010029" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc0402 MBC}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

{cdp/cdcfgint.i} /* definiá∆o do pre-processador da release do banco */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */
{bcp/bcapi002.i}
{bcp/bcapi011.i}
{cdp/cd0666.i}
{include/i_dbtype.i}
{bcp/bcproxy.i2}    /* DefiniªÑes das procedures para integraªío com o Magnus i.00 */
{include/i_dbvers.i}
define temp-table tt-etiqueta-aux		  NO-UNDO like tt-etiqueta.

define temp-table tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field cd-trans-ini     like bc-trans.cd-trans
    field cd-trans-fim     like bc-trans.cd-trans
    field data-geracao-ini like bc-trans.data
    field data-geracao-fim like bc-trans.data
    field hora-geracao-ini like bc-trans.horario
    field hora-geracao-fim like bc-trans.horario
    field de-nr-trans-ini  like bc-trans.nr-trans
    field de-nr-trans-fim  like bc-trans.nr-trans
    field c-arq-saida      as char format "x(30)"
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo        LIKE empresa.ep-codigo format "x(03)".
&ELSE
    field ep-codigo        as int format ">>9".
&ENDIF

define temp-table tt-digita no-undo
    field i-tipo        as inte
    field i-sequen      as inte
    field nr-trans      as deci format "zzzzzzzzz9"
    field cd-trans      as char format "x(8)".

def var raw-param        as raw no-undo.
def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.
                    
/* Local Variable Definitions ---                                       */

def var l-ok                as logical      no-undo.
def var c-arq-digita        as char         no-undo.
def var c-terminal          as char         no-undo.
def var c-tipo              as log  format "Etiqueta/Total" initial yes label "Tipo".
def var rw-nr-trans         as rowid        no-undo.
def var i-qtd-etiq          as deci         no-undo.
def var rw-trans            as raw          no-undo.
def var h-acomp             as handle       no-undo.
def var c-detalhe1          as char         format "X(20)"  no-undo.
def var c-detalhe2          as char         format "X(20)"  no-undo.
def var c-detalhe3          as char         format "X(20)"  no-undo.
def var c-detalhe4          as char         format "X(20)"  no-undo.
def var c-detalhe5          as char         format "X(20)"  no-undo.

def var c-i-trans           as char.
def var c-f-trans           as char.
def var c-i-nr-trans        as char.
def var c-f-nr-trans        as char.
def var c-i-data            as char.
def var c-f-data            as char.
def var c-i-hora            as char.
def var c-f-hora            as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES bc-trans tt-etiqueta

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita bc-trans.cd-trans ~
bc-trans.nr-trans bc-trans.data bc-trans.horario ~
SUBSTRING(bc-trans.detalhe,1,20) @ c-detalhe1 ~
SUBSTRING(bc-trans.detalhe,21,20) @ c-detalhe2 ~
SUBSTRING(bc-trans.detalhe,41,20) @ c-detalhe3 ~
SUBSTRING(bc-trans.detalhe,61,20) @ c-detalhe4 ~
SUBSTRING(bc-trans.detalhe,81,20) @ c-detalhe5 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita 
&Scoped-define OPEN-QUERY-br-digita OPEN QUERY br-digita FOR EACH bc-trans ~
      WHERE bc-trans.cd-trans >= c-ini-trans ~
 AND bc-trans.cd-trans <= c-fim-trans ~
 AND bc-trans.nr-trans >= i-ini-nr-trans ~
 AND bc-trans.nr-trans <= i-fim-nr-trans ~
 AND bc-trans.data >= dt-ini-geracao ~
 AND bc-trans.data <= dt-fim-geracao ~
 AND bc-trans.horario >= hr-ini ~
 AND bc-trans.horario <= hr-fim ~
 AND  ~
&if '{&mgcld_version}' < '2.04' &then ~
 bc-trans.log-1 = yes ~
&else ~
 bc-trans.ind-tipo-trans = 1 ~
&endif NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-digita bc-trans
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita bc-trans


/* Definitions for BROWSE br-digita-mult                                */
&Scoped-define FIELDS-IN-QUERY-br-digita-mult bc-trans.cd-trans ~
bc-trans.nr-trans bc-trans.data ~
SUBSTRING(bc-trans.detalhe,1,20) @ c-detalhe1 ~
SUBSTRING(bc-trans.detalhe,21,20) @ c-detalhe2 ~
SUBSTRING(bc-trans.detalhe,41,20) @ c-detalhe3 ~
SUBSTRING(bc-trans.detalhe,61,20) @ c-detalhe4 ~
SUBSTRING(bc-trans.detalhe,81,20) @ c-detalhe5 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita-mult 
&Scoped-define OPEN-QUERY-br-digita-mult OPEN QUERY br-digita-mult FOR EACH bc-trans ~
      WHERE bc-trans.cd-trans >= c-ini-trans ~
 AND bc-trans.cd-trans <= c-fim-trans ~
 AND bc-trans.nr-trans >= i-ini-nr-trans ~
 AND bc-trans.nr-trans <= i-fim-nr-trans ~
 AND bc-trans.data >= dt-ini-geracao ~
 AND bc-trans.data <= dt-fim-geracao ~
 AND bc-trans.horario >= hr-ini ~
 AND bc-trans.horario <= hr-fim ~
 AND  ~
&if '{&mgcld_version}' < '2.04' &then ~
  bc-trans.log-1 = yes ~
&else ~
  bc-trans.ind-tipo-trans = 1 ~
&endif NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-digita-mult bc-trans
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita-mult bc-trans


/* Definitions for BROWSE br-sel-sequencia                              */
&Scoped-define FIELDS-IN-QUERY-br-sel-sequencia c-Tipo tt-etiqueta.i-sequen tt-etiqueta.quantidade tt-etiqueta.it-codigo tt-etiqueta.qt-etiqueta tt-etiqueta.tipo-etiq tt-etiqueta.cod-estabel tt-etiqueta.cod-depos tt-etiqueta.cod-localiz   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-sel-sequencia   
&Scoped-define SELF-NAME br-sel-sequencia
&Scoped-define OPEN-QUERY-br-sel-sequencia OPEN QUERY br-sel-sequencia FOR EACH tt-etiqueta.
&Scoped-define TABLES-IN-QUERY-br-sel-sequencia tt-etiqueta
&Scoped-define FIRST-TABLE-IN-QUERY-br-sel-sequencia tt-etiqueta


/* Definitions for FRAME f-pg-dig                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-dig ~
    ~{&OPEN-QUERY-br-sel-sequencia}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-nr-transacao br-sel-sequencia ~
br-digita-mult br-digita RECT-10 RECT-11 RECT-12 
&Scoped-Define DISPLAYED-OBJECTS tg-nr-transacao tg-seq-transacao ~
tg-wordindex c-wordindex 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-deselecionar 
     IMAGE-UP FILE "image~\im-ran5":U
     IMAGE-INSENSITIVE FILE "image~\im-ran5i":U
     LABEL "" 
     SIZE 5.72 BY 1.13 TOOLTIP "Deseleciona".

DEFINE BUTTON bt-va-para 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "" 
     SIZE 5.72 BY 1.13 TOOLTIP "Va Para Sequencia".

DEFINE BUTTON bt-word 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-wordindex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.86 BY .88 TOOLTIP "Condiá∆o ~"OU~" (Datasul | Item); Condiá∆o ~"E~" (Datasul & Item)" NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 1.25.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 9.08.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37 BY 2.25.

DEFINE VARIABLE tg-nr-transacao AS LOGICAL INITIAL no 
     LABEL "N£mero de Transaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE VARIABLE tg-seq-transacao AS LOGICAL INITIAL no 
     LABEL "Sequencia de Etiqueta" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 NO-UNDO.

DEFINE VARIABLE tg-wordindex AS LOGICAL INITIAL no 
     LABEL "Selecionar por Detalhe" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .75 NO-UNDO.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE c-fim-trans AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-ini-trans AS CHARACTER FORMAT "X(08)":U 
     LABEL "Transaá∆o Inicial" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dt-fim-geracao AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dt-ini-geracao AS DATE FORMAT "99/99/9999":U INITIAL 01/01/00 
     LABEL "Data Geraá∆o Inicial" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE hr-fim AS CHARACTER FORMAT "99:99:99":U INITIAL "999999" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE hr-ini AS CHARACTER FORMAT "99:99:99":U INITIAL "000000" 
     LABEL "Hora Geraá∆o Inicial" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-fim-nr-trans AS DECIMAL FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-ini-nr-trans AS DECIMAL FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Nr.Transaá∆o Inicial" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

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
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-dig
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0  
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0  
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0  
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0  
     SIZE 78.72 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-digita FOR 
      bc-trans SCROLLING.

DEFINE QUERY br-digita-mult FOR 
      bc-trans SCROLLING.

DEFINE QUERY br-sel-sequencia FOR 
      tt-etiqueta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita w-relat _STRUCTURED
  QUERY br-digita NO-LOCK DISPLAY
      bc-trans.cd-trans FORMAT "x(8)":U
      bc-trans.nr-trans FORMAT "zzzzzzzzz9":U
      bc-trans.data FORMAT "99/99/9999":U
      bc-trans.horario FORMAT "x(08)":U
      SUBSTRING(bc-trans.detalhe,1,20) @ c-detalhe1 COLUMN-LABEL "Detalhe"
      SUBSTRING(bc-trans.detalhe,21,20) @ c-detalhe2 COLUMN-LABEL "Complemento Detalhe"
      SUBSTRING(bc-trans.detalhe,41,20) @ c-detalhe3 COLUMN-LABEL "Complemento Detalhe"
      SUBSTRING(bc-trans.detalhe,61,20) @ c-detalhe4 COLUMN-LABEL "Complemento Detalhe"
      SUBSTRING(bc-trans.detalhe,81,20) @ c-detalhe5 COLUMN-LABEL "Complemento Detalhe"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 37 BY 6.

DEFINE BROWSE br-digita-mult
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita-mult w-relat _STRUCTURED
  QUERY br-digita-mult NO-LOCK DISPLAY
      bc-trans.cd-trans FORMAT "x(8)":U
      bc-trans.nr-trans FORMAT "zzzzzzzzz9":U
      bc-trans.data FORMAT "99/99/9999":U
      SUBSTRING(bc-trans.detalhe,1,20) @ c-detalhe1 COLUMN-LABEL "Detalhe"
      SUBSTRING(bc-trans.detalhe,21,20) @ c-detalhe2 COLUMN-LABEL "Complemento Detalhe"
      SUBSTRING(bc-trans.detalhe,41,20) @ c-detalhe3 COLUMN-LABEL "Complemento Detalhe"
      SUBSTRING(bc-trans.detalhe,61,20) @ c-detalhe4 COLUMN-LABEL "Complemento Detalhe"
      SUBSTRING(bc-trans.detalhe,81,20) @ c-detalhe5 COLUMN-LABEL "Complemento Detalhe"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 37 BY 6.

DEFINE BROWSE br-sel-sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-sel-sequencia w-relat _FREEFORM
  QUERY br-sel-sequencia DISPLAY
      c-Tipo
    tt-etiqueta.i-sequen    format ">>>,>>9"
    tt-etiqueta.quantidade  format ">>>,>>9.9999"
    tt-etiqueta.it-codigo
    tt-etiqueta.qt-etiqueta
    tt-etiqueta.tipo-etiq format "9999"
    tt-etiqueta.cod-estabel
    tt-etiqueta.cod-depos
    tt-etiqueta.cod-localiz
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 36 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 10.5.

DEFINE FRAME f-pg-sel
     c-ini-trans AT ROW 2.5 COL 28 COLON-ALIGNED
     c-fim-trans AT ROW 2.5 COL 49 COLON-ALIGNED NO-LABEL
     i-ini-nr-trans AT ROW 3.75 COL 28 COLON-ALIGNED
     i-fim-nr-trans AT ROW 3.75 COL 49 COLON-ALIGNED NO-LABEL
     dt-ini-geracao AT ROW 5 COL 28 COLON-ALIGNED
     dt-fim-geracao AT ROW 5 COL 49 COLON-ALIGNED NO-LABEL
     hr-ini AT ROW 6.25 COL 28 COLON-ALIGNED
     hr-fim AT ROW 6.25 COL 49 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 2.5 COL 45
     IMAGE-10 AT ROW 5 COL 48
     IMAGE-11 AT ROW 3.75 COL 45
     IMAGE-12 AT ROW 3.75 COL 48
     IMAGE-13 AT ROW 6.25 COL 48
     IMAGE-14 AT ROW 6.25 COL 45
     IMAGE-2 AT ROW 2.5 COL 48
     IMAGE-9 AT ROW 5 COL 45
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 77 BY 10.5.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     im-pg-dig AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-dig
     tg-nr-transacao AT ROW 1.25 COL 2
     tg-seq-transacao AT ROW 1.25 COL 40
     br-sel-sequencia AT ROW 2.5 COL 40
     tg-wordindex AT ROW 2.75 COL 3
     c-wordindex AT ROW 3.5 COL 1 COLON-ALIGNED NO-LABEL
     bt-word AT ROW 3.5 COL 34
     br-digita-mult AT ROW 5 COL 2
     br-digita AT ROW 5 COL 2.14
     bt-deselecionar AT ROW 10 COL 40
     bt-va-para AT ROW 10 COL 70.43
     RECT-10 AT ROW 1 COL 1
     RECT-11 AT ROW 2.25 COL 1
     RECT-12 AT ROW 2.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.96
         SIZE 77 BY 10.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "ReImpress∆o de Etiquetas"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-dig
                                                                        */
/* BROWSE-TAB br-sel-sequencia tg-seq-transacao f-pg-dig */
/* BROWSE-TAB br-digita-mult bt-word f-pg-dig */
/* BROWSE-TAB br-digita br-digita-mult f-pg-dig */
/* SETTINGS FOR BUTTON bt-deselecionar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-va-para IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-word IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-wordindex IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-seq-transacao IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-wordindex IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita
/* Query rebuild information for BROWSE br-digita
     _TblList          = "mgcld.bc-trans"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgcld.bc-trans.cd-trans >= c-ini-trans
 AND mgcld.bc-trans.cd-trans <= c-fim-trans
 AND mgcld.bc-trans.nr-trans >= i-ini-nr-trans
 AND mgcld.bc-trans.nr-trans <= i-fim-nr-trans
 AND mgcld.bc-trans.data >= dt-ini-geracao
 AND mgcld.bc-trans.data <= dt-fim-geracao
 AND mgcld.bc-trans.horario >= hr-ini
 AND mgcld.bc-trans.horario <= hr-fim
 AND 
&if '{&mgcld_version}' < '2.04' &then
 mgcld.bc-trans.log-1 = yes
&else
 mgcld.bc-trans.ind-tipo-trans = 1
&endif"
     _FldNameList[1]   = mgcld.bc-trans.cd-trans
     _FldNameList[2]   = mgcld.bc-trans.nr-trans
     _FldNameList[3]   = mgcld.bc-trans.data
     _FldNameList[4]   = mgcld.bc-trans.horario
     _FldNameList[5]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,1,20) @ c-detalhe1" "Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[6]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,21,20) @ c-detalhe2" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,41,20) @ c-detalhe3" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,61,20) @ c-detalhe4" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[9]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,81,20) @ c-detalhe5" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE br-digita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita-mult
/* Query rebuild information for BROWSE br-digita-mult
     _TblList          = "mgcld.bc-trans"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgcld.bc-trans.cd-trans >= c-ini-trans
 AND mgcld.bc-trans.cd-trans <= c-fim-trans
 AND mgcld.bc-trans.nr-trans >= i-ini-nr-trans
 AND mgcld.bc-trans.nr-trans <= i-fim-nr-trans
 AND mgcld.bc-trans.data >= dt-ini-geracao
 AND mgcld.bc-trans.data <= dt-fim-geracao
 AND mgcld.bc-trans.horario >= hr-ini
 AND mgcld.bc-trans.horario <= hr-fim
 AND 
&if '{&mgcld_version}' < '2.04' &then
  mgcld.bc-trans.log-1 = yes
&else
  mgcld.bc-trans.ind-tipo-trans = 1
&endif"
     _FldNameList[1]   = mgcld.bc-trans.cd-trans
     _FldNameList[2]   = mgcld.bc-trans.nr-trans
     _FldNameList[3]   = mgcld.bc-trans.data
     _FldNameList[4]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,1,20) @ c-detalhe1" "Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,21,20) @ c-detalhe2" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[6]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,41,20) @ c-detalhe3" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,61,20) @ c-detalhe4" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   > "_<CALC>"
"SUBSTRING(bc-trans.detalhe,81,20) @ c-detalhe5" "Complemento Detalhe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE br-digita-mult */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-sel-sequencia
/* Query rebuild information for BROWSE br-sel-sequencia
     _START_FREEFORM
OPEN QUERY br-sel-sequencia FOR EACH tt-etiqueta.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-sel-sequencia */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* ReImpress∆o de Etiquetas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* ReImpress∆o de Etiquetas */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-pg-sel w-relat
ON LEAVE OF FRAME f-pg-sel
DO:
    if  input frame f-pg-dig tg-nr-transacao = yes
    then do:
        if  c-ini-trans     :screen-value in frame f-pg-sel <> c-i-trans
        or  c-fim-trans     :screen-value in frame f-pg-sel <> c-f-trans
        or  dt-ini-geracao  :screen-value in frame f-pg-sel <> c-i-data
        or  dt-fim-geracao  :screen-value in frame f-pg-sel <> c-f-data
        or  hr-ini          :screen-value in frame f-pg-sel <> c-i-hora
        or  hr-fim          :screen-value in frame f-pg-sel <> c-f-hora
        or  i-ini-nr-trans  :screen-value in frame f-pg-sel <> c-i-nr-trans
        or  i-fim-nr-trans  :screen-value in frame f-pg-sel <> c-f-nr-trans
        then do:
            assign  c-ini-trans     c-fim-trans
                    i-ini-nr-trans  i-fim-nr-trans
                    dt-ini-geracao  dt-fim-geracao
                    hr-ini          hr-fim.
            {&OPEN-QUERY-br-digita}
            {&OPEN-QUERY-br-digita-mult}
            {&OPEN-QUERY-br-sel-sequencia}
        end.
    end.    
    assign  c-i-trans       = c-ini-trans   :screen-value in frame f-pg-sel
            c-f-trans       = c-fim-trans   :screen-value in frame f-pg-sel
            c-i-data        = dt-ini-geracao:screen-value in frame f-pg-sel
            c-f-data        = dt-fim-geracao:screen-value in frame f-pg-sel
            c-i-hora        = hr-ini        :screen-value in frame f-pg-sel
            c-f-hora        = hr-fim        :screen-value in frame f-pg-sel
            c-i-nr-trans    = i-ini-nr-trans:screen-value in frame f-pg-sel
            c-f-nr-trans    = i-fim-nr-trans:screen-value in frame f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON VALUE-CHANGED OF br-digita IN FRAME f-pg-dig
DO:
    if  tg-seq-transacao:checked in frame f-pg-dig
    and avail bc-trans
    then DO:
        run pi-fatora-etiqueta.
    END.
    else CLOSE QUERY br-sel-sequencia.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita-mult
&Scoped-define SELF-NAME br-digita-mult
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-mult w-relat
ON VALUE-CHANGED OF br-digita-mult IN FRAME f-pg-dig
DO:
    assign  rw-nr-trans = rowid(bc-trans).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-sel-sequencia
&Scoped-define SELF-NAME br-sel-sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-sel-sequencia w-relat
ON ROW-DISPLAY OF br-sel-sequencia IN FRAME f-pg-dig
DO:
    if  tt-etiqueta.i-sequen > i-qtd-etiq
    then assign c-tipo                  :bgcolor in browse {&BROWSE-NAME} = 8
                tt-etiqueta.i-sequen    :bgcolor in browse {&browse-name} = 8
                tt-etiqueta.quantidade  :bgcolor in browse {&BROWSE-NAME} = 8
                c-tipo = no.
    else assign tt-etiqueta.i-sequen   :bgcolor in browse {&browse-name} = ?
                tt-etiqueta.i-sequen   :fgcolor in browse {&browse-name} = ?
                tt-etiqueta.quantidade :bgcolor in browse {&BROWSE-NAME} = ?
                tt-etiqueta.quantidade :fgcolor in browse {&BROWSE-NAME} = ?
                c-tipo = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-deselecionar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-deselecionar w-relat
ON CHOOSE OF bt-deselecionar IN FRAME f-pg-dig
DO:
    {&OPEN-QUERY-br-sel-sequencia}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-va-para w-relat
ON CHOOSE OF bt-va-para IN FRAME f-pg-dig
DO:
    run pi-va-para.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-word
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-word w-relat
ON CHOOSE OF bt-word IN FRAME f-pg-dig
DO:
    if  tg-wordindex:checked in frame f-pg-dig
    then do:
        OPEN QUERY br-digita
            FOR  EACH BC-TRANS NO-LOCK 
                WHERE mgcld.bc-trans.cd-trans   >= c-ini-trans
                  AND mgcld.bc-trans.cd-trans   <= c-fim-trans
                  AND mgcld.bc-trans.nr-trans   >= i-ini-nr-trans
                  AND mgcld.bc-trans.nr-trans   <= i-fim-nr-trans
                  AND mgcld.bc-trans.data       >= dt-ini-geracao
                  AND mgcld.bc-trans.data       <= dt-fim-geracao
                  AND mgcld.bc-trans.horario    >= hr-ini
                  AND mgcld.bc-trans.horario    <= hr-fim
                  AND &if '{&mgcld_version}' < '2.04' &then
                           mgcld.bc-trans.log-1       = yes
                      &else 
                           mgcld.bc-trans.ind-tipo-trans = 1
                      &endif    
                          
                  AND ( &IF "{&mgmp_dbtype}" = "PROGRESS"
                        &THEN bc-trans.detalhe contains(c-wordindex :screen-value in frame f-pg-dig)
                        &ELSE bc-trans.detalhe MATCHES c-wordindex  :screen-value in frame f-pg-dig
                        &ENDIF).

        OPEN QUERY br-digita-mult
            FOR  EACH BC-TRANS NO-LOCK 
                WHERE mgcld.bc-trans.cd-trans   >= c-ini-trans
                  AND mgcld.bc-trans.cd-trans   <= c-fim-trans
                  AND mgcld.bc-trans.nr-trans   >= i-ini-nr-trans
                  AND mgcld.bc-trans.nr-trans   <= i-fim-nr-trans
                  AND mgcld.bc-trans.data       >= dt-ini-geracao
                  AND mgcld.bc-trans.data       <= dt-fim-geracao
                  AND mgcld.bc-trans.horario    >= hr-ini
                  AND mgcld.bc-trans.horario    <= hr-fim
                  AND &if '{&mgcld_version}' < '2.04' &then
                           mgcld.bc-trans.log-1       = yes
                      &else 
                           mgcld.bc-trans.ind-tipo-trans = 1
                      &endif    
                  AND ( &IF "{&mgmp_dbtype}" = "PROGRESS"
                        &THEN bc-trans.detalhe contains(c-wordindex :screen-value in frame f-pg-dig)
                        &ELSE bc-trans.detalhe MATCHES c-wordindex  :screen-value in frame f-pg-dig
                        &ENDIF).
        assign  rw-nr-trans = rowid(bc-trans).
        apply "value-changed" to tg-seq-transacao.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig w-relat
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME tg-nr-transacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-nr-transacao w-relat
ON VALUE-CHANGED OF tg-nr-transacao IN FRAME f-pg-dig /* N£mero de Transaá∆o */
DO:
    if  tg-seq-transacao:checked in frame f-pg-dig
    then do:
        hide browse br-digita-mult.
        view browse br-digita.
    end.
    else do:
        hide browse br-digita.
        view browse br-digita-mult.
    end.

    assign  tg-seq-transacao:sensitive      in frame f-pg-dig = tg-nr-transacao :checked in frame f-pg-dig
            tg-seq-transacao:checked        in frame f-pg-dig = no
            tg-wordindex    :sensitive      in frame f-pg-dig = tg-nr-transacao :checked in frame f-pg-dig
            tg-wordindex    :checked        in frame f-pg-dig = no
            bt-word         :sensitive      in frame f-pg-dig = tg-wordindex    :checked in frame f-pg-dig
            c-wordindex     :sensitive      in frame f-pg-dig = tg-wordindex    :checked in frame f-pg-dig
            c-wordindex     :screen-value   in frame f-pg-dig = "".

    do with frame f-pg-sel:
        assign  c-ini-trans
                c-fim-trans
                i-ini-nr-trans
                i-fim-nr-trans
                dt-ini-geracao
                dt-fim-geracao
                hr-ini
                hr-fim.
    end.

    if  tg-nr-transacao:checked in frame f-pg-dig
    then do:
        {&OPEN-QUERY-br-digita}
        {&OPEN-QUERY-br-digita-mult}
        if  tg-seq-transacao:checked in frame f-pg-dig
        then {&OPEN-QUERY-br-sel-sequencia}
    end.
    else do:
        CLOSE QUERY br-digita.
        CLOSE QUERY br-digita-mult.
        CLOSE QUERY br-sel-sequencia.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-seq-transacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-seq-transacao w-relat
ON VALUE-CHANGED OF tg-seq-transacao IN FRAME f-pg-dig /* Sequencia de Etiqueta */
DO:
    
    do with frame f-pg-dig:
        
         assign  bt-va-para      :sensitive = tg-seq-transacao:checked 
                bt-deselecionar :sensitive = tg-seq-transacao:checked.

        if  tg-seq-transacao:checked
        then do:

            hide browse br-digita-mult.
            view browse br-digita.

            if  tg-wordindex:checked
            then apply "choose" to bt-word.
            else {&OPEN-QUERY-br-digita}

            if  avail bc-trans
            then do:               
                
                reposition br-digita TO ROWID rw-nr-trans no-error.
                run pi-fatora-etiqueta.
                {&OPEN-QUERY-br-sel-sequencia}
            end.
            else do:
                for each tt-etiqueta.
                    delete tt-etiqueta.
                end.
                CLOSE QUERY br-sel-sequencia.
            end.
        end.
        else do:
            hide browse br-digita.
            view browse br-digita-mult.

            if  tg-wordindex:checked
            then apply "choose" to bt-word.
            else {&OPEN-QUERY-br-digita-mult}

            reposition br-digita to ROW 1.

            for each tt-etiqueta.
                delete tt-etiqueta.
            end.
            CLOSE QUERY br-sel-sequencia.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-wordindex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-wordindex w-relat
ON VALUE-CHANGED OF tg-wordindex IN FRAME f-pg-dig /* Selecionar por Detalhe */
DO:
    assign  c-wordindex     :sensitive      in frame f-pg-dig = tg-wordindex:checked in frame f-pg-dig
            bt-word         :sensitive      in frame f-pg-dig = tg-wordindex:checked in frame f-pg-dig
            c-wordindex     :screen-value   in frame f-pg-dig = "".

    if  not tg-wordindex:checked in frame f-pg-dig
    then do:
        {&OPEN-QUERY-br-digita}
        {&OPEN-QUERY-br-digita-mult}
        assign  rw-nr-trans = rowid(bc-trans).
        apply "value-changed" to tg-seq-transacao.
        {&OPEN-QUERY-br-sel-sequencia}
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "BC0402" "2.00.00.029"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    assign  dt-ini-geracao:screen-value           in frame f-pg-sel = "01/01/" + string(year(today),"9999")
            dt-fim-geracao:screen-value           in frame f-pg-sel = string(today, "99/99/9999").

    {utp/ut-liter.i "Item" * 1}
    assign  tt-etiqueta.it-codigo   :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i "Quantidade" * 1}
    assign  tt-etiqueta.quantidade  :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i "Qt.Etiq" * 1}
    assign  tt-etiqueta.qt-etiqueta :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i "Depos" * 1}
    assign  tt-etiqueta.cod-depos   :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i "Estabel" * 1}
    assign  tt-etiqueta.cod-estabel :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i "Localiz" * 1}
    assign  tt-etiqueta.cod-localiz :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i "Tp.Etiq" * 1}
    assign  tt-etiqueta.tipo-etiq   :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i "Sequen" * 1}
    assign  tt-etiqueta.i-sequen    :label in browse br-sel-sequencia = trim(return-value).
    {utp/ut-liter.i Deseleciona * C}
    assign  bt-deselecionar:tooltip in frame {&FRAME-NAME} = trim(return-value).
    {utp/ut-liter.i V†_para_Sequància * C}
    assign  bt-va-para:tooltip in frame {&FRAME-NAME} = trim(return-value).
    {utp/ut-liter.i "Para Multi-Seleá∆o mantenha pressionado Ctrl + Click" * L}
    IF integer(entry(1,proversion,".")) >= 9 THEN
    assign  br-sel-sequencia:tooltip in frame {&FRAME-NAME} = trim(return-value)
            br-sel-sequencia:help    in frame {&FRAME-NAME} = trim(return-value).
    
    
    
    &IF "{&mgmp_dbtype}" = "PROGRESS"
    &THEN {utp/ut-liter.i "Condiá∆o "OU" (Datasul | Item); Condiá∆o "E" (Datasul & Item)" * 1}
    &ELSE {utp/ut-liter.i "Uma Palavra (Datasul*); Todas as Palavras com "Item" (*Item*)" * 1}
    &ENDIF
    assign  c-wordindex:tooltip in frame f-pg-dig = trim(return-value).
  
    {include/i-rpmbl.i}
  
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE bt-executar bt-cancelar bt-ajuda im-pg-dig im-pg-imp im-pg-sel 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY c-ini-trans c-fim-trans i-ini-nr-trans i-fim-nr-trans dt-ini-geracao 
          dt-fim-geracao hr-ini hr-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE c-ini-trans c-fim-trans i-ini-nr-trans i-fim-nr-trans dt-ini-geracao 
         dt-fim-geracao hr-ini hr-fim IMAGE-1 IMAGE-10 IMAGE-11 IMAGE-12 
         IMAGE-13 IMAGE-14 IMAGE-2 IMAGE-9 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY tg-nr-transacao tg-seq-transacao tg-wordindex c-wordindex 
      WITH FRAME f-pg-dig IN WINDOW w-relat.
  ENABLE tg-nr-transacao br-sel-sequencia br-digita-mult br-digita RECT-10 
         RECT-11 RECT-12 
      WITH FRAME f-pg-dig IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE rs-destino bt-config-impr bt-arquivo c-arquivo rs-execucao RECT-7 
         RECT-9 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-relat 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    do with frame f-pg-dig:
        hide browse br-digita.
        view browse br-digita-mult.
    end.
    apply "mouse-select-click" to im-pg-sel in frame f-relat.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid     no-undo.
define var i-select    as integer   no-undo.
define var i-cont      as integer   no-undo.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}

    if input frame f-pg-sel dt-ini-geracao > 
       input frame f-pg-sel dt-fim-geracao
    then do:
        run utp/ut-msgs.p (input "show",
                           input 515,
                           input dt-ini-geracao:screen-value in frame f-pg-sel + "~~" +
                                 dt-fim-geracao:screen-value in frame f-pg-sel).
        apply 'mouse-select-click' to im-pg-sel in frame f-relat.
        apply "entry" to dt-ini-geracao in frame f-pg-sel.
        return error.
    end.

    if i-ini-nr-trans:screen-value in frame f-pg-sel > 
       i-fim-nr-trans:screen-value in frame f-pg-sel
    then do:
        run utp/ut-msgs.p (input "show",
                           input 515,
                           input i-ini-nr-trans:screen-value in frame f-pg-sel + "~~" +
                                 i-fim-nr-trans:screen-value in frame f-pg-sel).
        apply 'mouse-select-click' to im-pg-sel in frame f-relat.
        apply "entry" to i-ini-nr-trans in frame f-pg-sel.
        return error.
    end.

    if  input frame f-pg-imp rs-destino     = 2
    and input frame f-pg-imp rs-execucao    = 1
    then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if  return-value = "NOK":U
        then do:
            run utp/ut-msgs.p (input "show", input 73, input "").

            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    if  tg-nr-transacao:checked in frame f-pg-dig
    then do:
        for each tt-digita:
            delete tt-digita.
        end.
        if  tg-seq-transacao:checked in frame f-pg-dig
        then do:
            assign i-select = br-sel-sequencia:num-selected-rows in frame f-pg-dig.
            IF i-select = 0 THEN DO:
                run utp/ut-msgs.p (input "show",
                                   input 28100,
                                   input "").
                apply 'mouse-select-click' to im-pg-dig in frame f-relat.
                apply "entry" to br-sel-sequencia in frame f-pg-dig.
                return error.
            END.
            do i-cont = 1 to i-select:
                if  br-sel-sequencia:fetch-selected-row(i-cont) in frame f-pg-dig
                then do:

                    create  tt-digita.
                    assign  tt-digita.i-tipo    = 2
                            tt-digita.nr-trans  = tt-etiqueta.nr-trans
                            tt-digita.cd-trans  = tt-etiqueta.cd-trans
                            tt-digita.i-sequen  = tt-etiqueta.i-sequen.
                end.
            end.
        end.
        else do:
            assign i-select = br-digita-mult:num-selected-rows in frame f-pg-dig.
            do i-cont = 1 to i-select:
                if  br-digita-mult:fetch-selected-row(i-cont) in frame f-pg-dig
                then do:

                    create  tt-digita.
                    assign  tt-digita.i-tipo    = 1
                            tt-digita.nr-trans  = bc-trans.nr-trans
                            tt-digita.cd-trans  = bc-trans.cd-trans.
                end.
            end.
        end.
    end.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.ep-codigo       = v_cdn_empres_usuar.

    if  tt-param.destino = 1 then
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    assign tt-param.cd-trans-ini       = input frame f-pg-sel c-ini-trans
           tt-param.cd-trans-fim       = input frame f-pg-sel c-fim-trans
           tt-param.data-geracao-ini   = input frame f-pg-sel dt-ini-geracao
           tt-param.data-geracao-fim   = input frame f-pg-sel dt-fim-geracao
           tt-param.de-nr-trans-ini    = input frame f-pg-sel i-ini-nr-trans
           tt-param.de-nr-trans-fim    = input frame f-pg-sel i-fim-nr-trans
           tt-param.hora-geracao-ini   = input frame f-pg-sel hr-ini
           tt-param.hora-geracao-fim   = input frame f-pg-sel hr-fim.

    /* Executar do programa RP.P que ir† criar o relat¢rio */

    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i bcp/bc0402rp.p}
    
    {include/i-rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).

    {include/i-rptrm.i}

end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fatora-etiqueta w-relat 
PROCEDURE pi-fatora-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
def var c-traduztexto as char.

&IF '{&mgcld_version}' > '2.03' &then

FIND FIRST bc-trans-filho
     WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans
     NO-LOCK NO-ERROR.

IF  AVAIL bc-trans-filho THEN DO:
    RUN utp/ut-liter.p ("Bidimencional (2D)":U, "*":U,"R":U).
    run utp/ut-msgs.p (input "show":U,
                       input 16905,
                       input RETURN-VALUE).

    ASSIGN tg-seq-transacao:CHECKED IN FRAME f-pg-dig = NO.
    
    hide browse br-digita.
    view browse br-digita-mult.

    RETURN NO-APPLY.
END.
&ENDIF

run utp/ut-acomp.p persistent set h-acomp.

erro:
do on stop undo erro, leave erro
   on quit undo erro, leave erro:
    {utp/ut-liter.i Nr.Trans * L}
    assign c-traduztexto = trim(return-value).
    {utp/ut-liter.i Processando * L}
    run pi-inicializar in h-acomp (input trim(return-value) + "...").
    {utp/ut-liter.i Fatorando_Trans * L}
    run pi-acompanhar  in h-acomp (input trim(return-value) + ": " + string(bc-trans.cd-trans,"X(08)") +
                                         ", " + c-traduztexto + string(bc-trans.nr-trans, "99999999")).

    for each tt-etiqueta-aux:
        delete tt-etiqueta-aux.
    end.
    for each tt-etiqueta:
        delete tt-etiqueta.
    end.

    &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
        assign  rw-trans = bc-trans.conteudo-trans.
    &ELSE
        /**** TRATAMENTO PARA BASES DE DADOS N«O PROGRESS ****/
        run btb/btb928za.p (input bc-trans.conteudo-trans, output rw-trans) no-error.
    
        if (  (    error-status:error
               or  error-status:get-number(1) <> 0)
            and error-status:get-number(1) <> 138
            and error-status:get-number(1) <> 91)
        or  return-value = "NOK"
        then do:
            {utp/ut-field.i mgcld bc-trans conteudo-trans 1}
            run utp/ut-msgs.p ( input "SHOW",
                                input 18895,
                                input return-value + " (RAW)").
    
            return "NOK".
         end.
    &ENDIF
    create  tt-etiqueta-aux.
    raw-transfer rw-trans to tt-etiqueta-aux NO-ERROR.
    
    /*TRATATIVA NECESSARIA POR CAUSA DA EVOLU∞ÄO DA TT-ETIQUETA*/
    IF ERROR-STATUS:ERROR
    AND ERROR-STATUS:GET-NUMBER(1) = 4955
    THEN DO:
        RAW-TRANSFER rw-trans to tt-etiqueta_old_v01 NO-ERROR.
        IF ERROR-STATUS:ERROR
        AND ERROR-STATUS:GET-NUMBER(1) = 4955
        THEN DO:
            RAW-TRANSFER rw-trans to tt-etiqueta_old NO-ERROR.
            BUFFER-COPY tt-etiqueta_old TO tt-etiqueta.
        END.
        ELSE DO:
            BUFFER-COPY tt-etiqueta_old_v01 TO tt-etiqueta.
        END.
    END.

    find first tt-etiqueta-aux no-error.

    for each tt-etq-item.
        delete tt-etq-item.
    end.

    run pi-verifica-emitente (  input "",
                                input "ZZZZZZZZZZZZZZZZZZZ",
                                input tt-etiqueta-aux.cod-emitente,
                                input tt-etiqueta-aux.cod-emitente,
                                input 5,
                                input 1).   /* for each item-cli */

    create  tt-etq-item.
    assign  tt-etq-item.cod-versao-integracao   = 1
            tt-etq-item.it-codigo               = tt-etiqueta-aux.it-codigo
            tt-etq-item.qt-item                 = tt-etiqueta-aux.quantidade
            tt-etq-item.cd-trans                = bc-trans.cd-trans
            tt-etq-item.nome-abrev              = ( if  avail ttEmitente
                                                    then ttEmitente.nome-abrev
                                                    else "").

    run bcp/bcapi011.p  (   input-output table tt-etq-item).
    find first tt-etq-item no-lock no-error.
    assign  i-qtd-etiq = tt-etq-item.qt-etiqueta.

    find first tt-etiqueta-aux no-error.
    assign  tt-etiqueta-aux.cd-trans      = bc-trans.cd-trans
            tt-etiqueta-aux.nr-trans      = bc-trans.nr-trans
            tt-etiqueta-aux.qt-etiqueta   = tt-etq-item.qt-etiqueta.

    run bcp/bcapi008.p  (   input-output table tt-etiqueta-aux,
                            input-output table tt-etiqueta,
                            input-output table tt-erro).

    run pi-finalizar in h-acomp.
end.

{&OPEN-QUERY-br-sel-sequencia}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-va-para w-relat 
PROCEDURE pi-va-para :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-nova-sequencia    as inte.

run  bcp/bc0103e.w  (output  i-nova-sequencia).

find first tt-etiqueta
     where tt-etiqueta.i-sequen = i-nova-sequencia
     no-lock no-error.

if  avail tt-etiqueta
then do:
    reposition br-sel-sequencia to rowid rowid(tt-etiqueta) no-error.
    if  br-sel-sequencia:select-focused-row() in frame f-pg-dig then.
end.
else do:
    find first tt-etiqueta no-lock no-error.
    if avail tt-etiqueta
    then if  br-sel-sequencia:select-focused-row() in frame f-pg-dig then.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-etiqueta"}
  {src/adm/template/snd-list.i "bc-trans"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

