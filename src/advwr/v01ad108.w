&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V01AD108 2.00.00.012}  /*** "010012" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad108 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def new global shared var v-row-parent as rowid no-undo.

def var da-data-sel    as date  init today                                no-undo.
/*def var da-ini-est     like emit-estat.data                               no-undo.
 * def var da-fim-est     like emit-estat.data                               no-undo.
 * def var i-cont         as integer                                         no-undo.
 * def var c-per-atraso   as character format "99/9999"            extent 12 no-undo.
 * def var i-atraso       as integer   format "->>9"               extent 13 no-undo.
 * def var i-recebimento  as integer   format "->>9"               extent 13 no-undo.
 * def var de-vendas      as decimal   format "->>,>>>,>>>,>>9.99" extent 13 no-undo.
 * def var de-atraso-acum as decimal   format "->>,>>>,>>>,>>9.99"           no-undo.
 * def var de-atraso-a    as decimal   format "->>,>>>,>>>,>>9.99"           no-undo.
 * def var de-prazo-acum  as decimal   format "->>,>>>,>>>,>>9.99"           no-undo.
 * def var de-cotacao     like titulo.cotacao-dia                            no-undo.*/

{cdp/cdcfgfin.i}   /* Miniflexibiliza‡Æo */

def buffer bf-emitente   for emitente.
def var v-log-sl-ab-venc as logical no-undo.
DEF VAR l-imprime-cli    AS LOGICAL NO-UNDO.                   

DEFINE temp-table tt-documento no-undo like titulo
       field row-documento  as rowid
       field c-modalidade   like titulo.modalidade
       field c-mo-codigo    as char format "x(03)"
       field de-saldo       like titulo.vl-saldo
       field de-saldo-me    like titulo.vl-saldo-me
       field i-dias         as int init 0
       field de-juros       as dec 
       field de-total-juros as dec.

define temp-table tt-estat no-undo

       field destino              as integer
       field arquivo              as char format "x(35)"
       field usuario              as char format "x(12)"
       field data-exec            as date
       field hora-exec            as integer
       field tipo-relat           as INTEGER
       FIELD cod-emitente         LIKE titulo.cod-emitente
       FIELD nome-abrev           LIKE titulo.nome-abrev
       FIELD fi-periodo           as char   FORMAT "99/9999"
       field da-data-conver       as date   FORMAT "99/99/9999"
       FIELD dt-maior-tit         AS DATE   FORMAT "99/99/9999"
       FIELD c-sigla-4            AS CHAR   FORMAT "X(5)"
       FIELD vl-maior-tit         AS DEC    FORMAT ">>>,>>>,>>>,>>9,9"
       FIELD dt-ult-tit           AS DATE   FORMAT "99/99/9999"
       FIELD c-sigla-5            AS CHAR   FORMAT "X(5)"
       FIELD vl-ult-tit           AS DEC    FORMAT ">>>,>>>,>>>,>>9,9"
       FIELD c-sigla-1            AS CHAR   FORMAT "X(5)"
       FIELD fi-vendas            AS DEC    FORMAT ">>>,>>>,>>>,>>9,9"
       FIELD c-sigla-2            AS CHAR   FORMAT "X(5)"
       FIELD fi-vendas-acumuladas AS DEC    FORMAT ">>>,>>>,>>>,>>9,9"
       FIELD c-sigla-3            AS CHAR   FORMAT "X(5)"
       FIELD fi-saldo-aberto      AS DEC    FORMAT ">>>,>>>,>>>,>>9,9"
       FIELD c-sigla-6            AS CHAR   FORMAT "X(5)"
       FIELD fi-saldo-aberto-venc AS DEC    FORMAT ">>>,>>>,>>>,>>9,9"
       field fi-label-periodo     as char   format "x(15)"
       field fi-periodo-1         as char   format "x(15)"
       field fi-periodo-2         as char   format "x(15)"
       field fi-periodo-3         as char   format "x(15)"
       field fi-periodo-4         as char   format "x(15)"
       field fi-periodo-5         as char   format "x(15)"
       field fi-periodo-6         as char   format "x(15)"
       field fi-periodo-7         as char   format "x(15)"
       field fi-periodo-8         as char   format "x(15)"
       field fi-periodo-9         as char   format "x(15)"
       field fi-periodo-10        as char   format "x(15)"
       field fi-periodo-11        as char   format "x(15)"
       field fi-periodo-12        as char   format "x(15)"
       FIELD fi-label-media       AS CHAR   FORMAT "x(15)"
       FIELD fi-label-atm         AS CHAR   FORMAT "x(15)"
       field fi-atm-1             as INT    format "->>9"
       field fi-atm-2             as INT    format "->>9"
       field fi-atm-3             as INT    format "->>9"
       field fi-atm-4             as INT    format "->>9"
       field fi-atm-5             as INT    format "->>9"
       field fi-atm-6             as INT    FORMAT "->>9"
       field fi-atm-7             as INT    format "->>9"
       field fi-atm-8             as INT    format "->>9"
       field fi-atm-9             as INT    format "->>9"
       field fi-atm-10            as INT    format "->>9"
       field fi-atm-11            as INT    format "->>9"
       field fi-atm-12            as INT    format "->>9"
       field fi-atm-media         as INT    format "->>9"
       FIELD fi-label-pmr         AS CHAR   FORMAT "x(15)"
       field fi-pmr-1             as INT    format "->>9"
       field fi-pmr-2             as INT    format "->>9"
       field fi-pmr-3             as INT    format "->>9"
       field fi-pmr-4             as INT    format "->>9"
       field fi-pmr-5             as INT    format "->>9"
       field fi-pmr-6             as INT    FORMAT "->>9"
       field fi-pmr-7             as INT    format "->>9"
       field fi-pmr-8             as INT    format "->>9"
       field fi-pmr-9             as INT    format "->>9"
       field fi-pmr-10            as INT    format "->>9"
       field fi-pmr-11            as INT    format "->>9"
       field fi-pmr-12            as INT    format "->>9"
       field fi-pmr-media         as INT    format "->>9"
       FIELD fi-label-vendas      AS CHAR   FORMAT "x(15)"
       field fi-vendas-1          as dec    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-2          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-3          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-4          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-5          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-6          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-7          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-8          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-9          as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-10         as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-11         as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-12         as DEC    format ">>>,>>>,>>>,>>9,9"
       field fi-vendas-media      as DEC    format ">>>,>>>,>>>,>>9,9".

define temp-table tt-liq no-undo

       FIELD c-barra         AS CHAR FORMAT "x(01)" INIT "/"
       FIELD c-barra2        LIKE c-barra           INIT "/"
       FIELD cod-emitente    LIKE titulo.cod-emitente
       FIELD nome-abrev      LIKE titulo.nome-abrev
       FIELD ep-codigo       LIKE mov-tit.ep-codigo
       FIELD cod-estabel     LIKE mov-tit.cod-estabel
       FIELD cod-esp         LIKE mov-tit.cod-esp
       FIELD serie           LIKE mov-tit.serie
       FIELD nr-docto        LIKE mov-tit.nr-docto
       FIELD parcela         LIKE mov-tit.parcela 
       FIELD vl-baixa        LIKE mov-tit.vl-baixa
       FIELD dt-credito      LIKE mov-tit.dt-credito
       FIELD dt-baixa        LIKE mov-tit.dt-baixa 
       FIELD cod-portador    LIKE mov-tit.cod-portador
       FIELD de-total-baixa  LIKE mov-tit.vl-baixa
       FIELD c-modalidade    AS CHAR
       FIELD vl-baixa-me     LIKE mov-tit.vl-baixa-me
       FIELD mo-codigo       LIKE mov-tit.mo-codigo
       FIELD cotacao-dia     LIKE mov-tit.cotacao-dia
       FIELD vl-desconto     LIKE mov-tit.vl-desconto
       FIELD vl-desconto-me  LIKE mov-tit.vl-desconto-me  
       FIELD vl-juros-rec    LIKE mov-tit.vl-juros-rec
       FIELD vl-juros-rec-me LIKE mov-tit.vl-juros-rec-me
       FIELD vl-desp-banc    LIKE mov-tit.vl-desp-banc 
       FIELD vl-desp-banc-me LIKE mov-tit.vl-desp-banc-me
       FIELD vl-abatimen     LIKE mov-tit.vl-abatimen
       FIELD vl-abatimen-me  LIKE mov-tit.vl-abatimen-me
       FIELD dt-vencimen     LIKE mov-tit.dt-vencimen
       FIELD esp-antecip     LIKE mov-tit.esp-antecip
       FIELD serie-antecip   LIKE mov-tit.serie-antecip
       FIELD doc-antecip     LIKE mov-tit.doc-antecip
       FIELD parc-antecip    LIKE mov-tit.parc-antecip 
       FIELD vl-antecip      LIKE mov-tit.vl-antecip
       FIELD vl-antecip-me   LIKE mov-tit.vl-antecip-me
       FIELD referencia      LIKE mov-tit.referencia 
       FIELD i-dias-atraso   AS INT.

define temp-table tt-hist no-undo
       FIELD cod-emitente LIKE titulo.cod-emitente
       FIELD nome-abrev   LIKE titulo.nome-abrev
       FIELD dt-his-emit  LIKE his-emit.dt-his-emit
       FIELD horario      LIKE his-emit.horario
       FIELD historico    LIKE his-emit.historico.

define temp-table tt-doc no-undo

       FIELD c-barra                      AS CHAR FORMAT "x(01)" INIT "/"
       FIELD c-barra2                     AS CHAR FORMAT "x(01)" INIT "/"
       FIELD cod-estabel                  LIKE titulo.cod-estabel
       FIELD cod-esp                      LIKE titulo.cod-esp
       FIELD serie                        LIKE titulo.serie
       FIELD nr-docto                     LIKE titulo.nr-docto
       FIELD parcela                      LIKE titulo.parcela
       FIELD cod-portador                 LIKE mov-tit.cod-portador
       FIELD c-modalidade                 AS CHAR
       FIELD vl-saldo                     LIKE titulo.vl-saldo
       FIELD vl-original                  LIKE titulo.vl-original
       field de-juros                     as dec
       FIELD de-total-juros               AS DEC
       FIELD dt-emissao                   LIKE titulo.dt-emissao
       FIELD dt-vencimen                  LIKE titulo.dt-vencimen
       FIELD cod-emitente                 LIKE titulo.cod-emitente
       FIELD nome-abrev                   LIKE titulo.nome-abrev
       FIELD i-dias                       AS int
       FIELD de-total-saldo-aberto        AS DEC
       FIELD de-saldo-anterior-do-cliente AS DEC.

def VAR r-emitente as rowid no-undo.
def VAR fi-total-titulos  as dec no-undo.
def VAR fi-total-matriz   as dec no-undo.
def VAR fi-saldo-anterior as dec no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estatist.dt-maior-tit estatist.vl-maior-tit ~
estatist.dt-ult-tit estatist.vl-ult-tit 
&Scoped-define ENABLED-TABLES estatist
&Scoped-define FIRST-ENABLED-TABLE estatist
&Scoped-define DISPLAYED-TABLES estatist
&Scoped-define FIRST-DISPLAYED-TABLE estatist
&Scoped-Define ENABLED-OBJECTS fi-periodo bt-confirma BT-IMP da-data-conver ~
RECT-1 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS estatist.dt-maior-tit estatist.vl-maior-tit ~
estatist.dt-ult-tit estatist.vl-ult-tit 
&Scoped-Define DISPLAYED-OBJECTS fi-label-periodo fi-label-atm fi-label-pmr ~
fi-label-vendas fi-periodo fi-periodo-1 fi-atm-1 fi-pmr-1 fi-vendas-1 ~
da-data-conver fi-periodo-2 fi-atm-2 fi-pmr-2 fi-vendas-2 fi-periodo-3 ~
fi-atm-3 fi-pmr-3 fi-vendas-3 c-sigla-4 fi-periodo-4 fi-atm-4 fi-pmr-4 ~
fi-vendas-4 fi-periodo-5 fi-atm-5 fi-pmr-5 fi-vendas-5 fi-periodo-6 ~
fi-atm-6 fi-pmr-6 fi-vendas-6 c-sigla-5 fi-periodo-7 fi-atm-7 fi-pmr-7 ~
fi-vendas-7 fi-periodo-8 fi-atm-8 fi-pmr-8 fi-vendas-8 c-sigla-1 fi-vendas ~
fi-periodo-9 fi-atm-9 fi-pmr-9 fi-vendas-9 c-sigla-2 fi-vendas-acumuladas ~
fi-periodo-10 fi-atm-10 fi-pmr-10 fi-vendas-10 c-sigla-3 fi-saldo-aberto ~
fi-periodo-11 fi-atm-11 fi-pmr-11 fi-vendas-11 fi-periodo-12 fi-atm-12 ~
fi-pmr-12 fi-vendas-12 c-sigla-6 fi-saldo-aberto-venc fi-atm-media ~
fi-pmr-media fi-vendas-media fi-label-media 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image~\im-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON BT-IMP 
     IMAGE-UP FILE "image/ii-pri.bmp":U
     LABEL "Imprimir" 
     SIZE 5 BY 1.

DEFINE VARIABLE c-sigla-1 AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla-2 AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla-3 AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla-4 AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla-5 AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla-6 AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-conver AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-atm-1 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-10 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-11 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-12 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-2 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-3 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-4 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-5 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-6 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-7 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-8 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-9 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-atm-media AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-label-atm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-label-media AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-label-periodo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-label-pmr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-label-vendas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "99/9999":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-1 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-10 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-11 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-12 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-2 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-3 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-4 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-5 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-6 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-7 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-8 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-periodo-9 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-1 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-10 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-11 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-12 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-2 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-3 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-4 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-5 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-6 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-7 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-8 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-9 AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-pmr-media AS INTEGER FORMAT "->>9":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-saldo-aberto AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-aberto-venc AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vendas AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vendas-1 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-10 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-11 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-12 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-2 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-3 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-4 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-5 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-6 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-7 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-8 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-9 AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE VARIABLE fi-vendas-acumuladas AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vendas-media AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 2.17.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 4.17.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-label-periodo AT ROW 1 COL 43 COLON-ALIGNED NO-LABEL
     fi-label-atm AT ROW 1 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-label-pmr AT ROW 1 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-label-vendas AT ROW 1 COL 65.43 COLON-ALIGNED NO-LABEL
     fi-periodo AT ROW 1.08 COL 19 COLON-ALIGNED
     bt-confirma AT ROW 1.08 COL 38
     BT-IMP AT ROW 2 COL 38
     fi-periodo-1 AT ROW 2 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-1 AT ROW 2 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-1 AT ROW 2 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-1 AT ROW 2 COL 65.43 COLON-ALIGNED NO-LABEL
     da-data-conver AT ROW 2.25 COL 19 COLON-ALIGNED
     fi-periodo-2 AT ROW 2.75 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-2 AT ROW 2.75 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-2 AT ROW 2.75 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-2 AT ROW 2.75 COL 65.43 COLON-ALIGNED NO-LABEL
     estatist.dt-maior-tit AT ROW 3.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     fi-periodo-3 AT ROW 3.5 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-3 AT ROW 3.5 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-3 AT ROW 3.5 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-3 AT ROW 3.5 COL 65.43 COLON-ALIGNED NO-LABEL
     c-sigla-4 AT ROW 4.25 COL 19 COLON-ALIGNED
     fi-periodo-4 AT ROW 4.25 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-4 AT ROW 4.25 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-4 AT ROW 4.25 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-4 AT ROW 4.25 COL 65.43 COLON-ALIGNED NO-LABEL
     estatist.vl-maior-tit AT ROW 4.29 COL 23.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-periodo-5 AT ROW 5 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-5 AT ROW 5 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-5 AT ROW 5 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-5 AT ROW 5 COL 65.43 COLON-ALIGNED NO-LABEL
     estatist.dt-ult-tit AT ROW 5.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     fi-periodo-6 AT ROW 5.75 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-6 AT ROW 5.75 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-6 AT ROW 5.75 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-6 AT ROW 5.75 COL 65.43 COLON-ALIGNED NO-LABEL
     estatist.vl-ult-tit AT ROW 6.29 COL 23.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-sigla-5 AT ROW 6.5 COL 19 COLON-ALIGNED
     fi-periodo-7 AT ROW 6.5 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-7 AT ROW 6.5 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-7 AT ROW 6.5 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-7 AT ROW 6.5 COL 65.43 COLON-ALIGNED NO-LABEL
     fi-periodo-8 AT ROW 7.25 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-8 AT ROW 7.25 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-8 AT ROW 7.25 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-8 AT ROW 7.25 COL 65.43 COLON-ALIGNED NO-LABEL
     c-sigla-1 AT ROW 7.5 COL 19 COLON-ALIGNED
     fi-vendas AT ROW 7.5 COL 23.43 COLON-ALIGNED NO-LABEL
     fi-periodo-9 AT ROW 8 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-9 AT ROW 8 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-9 AT ROW 8 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-9 AT ROW 8 COL 65.43 COLON-ALIGNED NO-LABEL
     c-sigla-2 AT ROW 8.5 COL 19 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     fi-vendas-acumuladas AT ROW 8.5 COL 23.43 COLON-ALIGNED NO-LABEL
     fi-periodo-10 AT ROW 8.75 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-10 AT ROW 8.75 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-10 AT ROW 8.75 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-10 AT ROW 8.75 COL 65.43 COLON-ALIGNED NO-LABEL
     c-sigla-3 AT ROW 9.5 COL 19 COLON-ALIGNED
     fi-saldo-aberto AT ROW 9.5 COL 23.43 COLON-ALIGNED NO-LABEL
     fi-periodo-11 AT ROW 9.5 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-11 AT ROW 9.5 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-11 AT ROW 9.5 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-11 AT ROW 9.5 COL 65.43 COLON-ALIGNED NO-LABEL
     fi-periodo-12 AT ROW 10.25 COL 43 COLON-ALIGNED NO-LABEL
     fi-atm-12 AT ROW 10.25 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-12 AT ROW 10.25 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-12 AT ROW 10.25 COL 65.43 COLON-ALIGNED NO-LABEL
     c-sigla-6 AT ROW 10.5 COL 19 COLON-ALIGNED
     fi-saldo-aberto-venc AT ROW 10.5 COL 23.43 COLON-ALIGNED NO-LABEL
     fi-atm-media AT ROW 11.25 COL 52.29 COLON-ALIGNED NO-LABEL
     fi-pmr-media AT ROW 11.25 COL 58.86 COLON-ALIGNED NO-LABEL
     fi-vendas-media AT ROW 11.25 COL 65.43 COLON-ALIGNED NO-LABEL
     fi-label-media AT ROW 11.29 COL 43 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1 COL 3
     RECT-3 AT ROW 3.21 COL 3
     RECT-4 AT ROW 7.42 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-sigla-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sigla-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sigla-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sigla-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sigla-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sigla-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-atm-media IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-atm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-media IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-periodo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-pmr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-vendas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pmr-media IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo-aberto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo-aberto-venc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-acumuladas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vendas-media IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma V-table-Win
ON CHOOSE OF bt-confirma IN FRAME f-main
DO:

    assign input frame {&FRAME-NAME} fi-periodo.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma V-table-Win
ON RETURN OF bt-confirma IN FRAME f-main
DO:

    apply 'choose':U to bt-confirma in frame {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-IMP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-IMP V-table-Win
ON CHOOSE OF BT-IMP IN FRAME f-main /* Imprimir */
DO:
    FOR EACH tt-estat EXCLUSIVE-LOCK:
        DELETE tt-estat.
    END.
    CREATE tt-estat.
    ASSIGN tt-estat.cod-emitente           = emitente.cod-emitente
           tt-estat.nome-abrev             = emitente.nome-abrev
           tt-estat.fi-periodo             = INPUT FRAME {&frame-name} fi-periodo    
           tt-estat.da-data-conver         = INPUT FRAME {&frame-name} da-data-conver   
           tt-estat.dt-maior-tit           = INPUT FRAME {&frame-name} estatist.dt-maior-tit
           tt-estat.c-sigla-4              = INPUT FRAME {&frame-name} c-sigla-4 
           tt-estat.vl-maior-tit           = INPUT FRAME {&frame-name} estatist.vl-maior-tit
           tt-estat.dt-ult-tit             = INPUT FRAME {&frame-name} estatist.dt-ult-tit
           tt-estat.c-sigla-5              = INPUT FRAME {&frame-name} c-sigla-5  
           tt-estat.vl-ult-tit             = INPUT FRAME {&frame-name} estatist.vl-ult-tit
           tt-estat.c-sigla-1              = INPUT FRAME {&frame-name} c-sigla-1
           tt-estat.fi-vendas              = INPUT FRAME {&frame-name} fi-vendas
           tt-estat.c-sigla-2              = INPUT FRAME {&frame-name} c-sigla-2 
           tt-estat.fi-vendas-acumuladas   = INPUT FRAME {&frame-name} fi-vendas-acumuladas
           tt-estat.c-sigla-3              = INPUT FRAME {&frame-name} c-sigla-3 
           tt-estat.fi-saldo-aberto        = INPUT FRAME {&frame-name} fi-saldo-aberto
           tt-estat.c-sigla-6              = INPUT FRAME {&frame-name} c-sigla-6      
           tt-estat.fi-saldo-aberto-venc   = INPUT FRAME {&frame-name} fi-saldo-aberto-venc 
           tt-estat.fi-label-periodo       = INPUT FRAME {&frame-name} fi-label-periodo 
           tt-estat.fi-periodo-1           = INPUT FRAME {&frame-name} fi-periodo-1 
           tt-estat.fi-periodo-2           = INPUT FRAME {&frame-name} fi-periodo-2
           tt-estat.fi-periodo-3           = INPUT FRAME {&frame-name} fi-periodo-3 
           tt-estat.fi-periodo-4           = INPUT FRAME {&frame-name} fi-periodo-4
           tt-estat.fi-periodo-5           = INPUT FRAME {&frame-name} fi-periodo-5 
           tt-estat.fi-periodo-6           = INPUT FRAME {&frame-name} fi-periodo-6
           tt-estat.fi-periodo-7           = INPUT FRAME {&frame-name} fi-periodo-7 
           tt-estat.fi-periodo-8           = INPUT FRAME {&frame-name} fi-periodo-8
           tt-estat.fi-periodo-9           = INPUT FRAME {&frame-name} fi-periodo-9 
           tt-estat.fi-periodo-10          = INPUT FRAME {&frame-name} fi-periodo-10
           tt-estat.fi-periodo-11          = INPUT FRAME {&frame-name} fi-periodo-11
           tt-estat.fi-periodo-12          = INPUT FRAME {&frame-name} fi-periodo-12
           tt-estat.fi-label-media         = INPUT FRAME {&frame-name} fi-label-media
           tt-estat.fi-label-atm           = INPUT FRAME {&frame-name} fi-label-atm
           tt-estat.fi-atm-1               = INPUT FRAME {&frame-name} fi-atm-1 
           tt-estat.fi-atm-2               = INPUT FRAME {&frame-name} fi-atm-2
           tt-estat.fi-atm-3               = INPUT FRAME {&frame-name} fi-atm-3 
           tt-estat.fi-atm-4               = INPUT FRAME {&frame-name} fi-atm-4
           tt-estat.fi-atm-5               = INPUT FRAME {&frame-name} fi-atm-5 
           tt-estat.fi-atm-6               = INPUT FRAME {&frame-name} fi-atm-6
           tt-estat.fi-atm-7               = INPUT FRAME {&frame-name} fi-atm-7 
           tt-estat.fi-atm-8               = INPUT FRAME {&frame-name} fi-atm-8
           tt-estat.fi-atm-9               = INPUT FRAME {&frame-name} fi-atm-9 
           tt-estat.fi-atm-10              = INPUT FRAME {&frame-name} fi-atm-10
           tt-estat.fi-atm-11              = INPUT FRAME {&frame-name} fi-atm-11
           tt-estat.fi-atm-12              = INPUT FRAME {&frame-name} fi-atm-12
           tt-estat.fi-atm-media           = INPUT FRAME {&frame-name} fi-atm-media 
           tt-estat.fi-label-pmr           = INPUT FRAME {&frame-name} fi-label-pmr
           tt-estat.fi-pmr-1               = INPUT FRAME {&frame-name} fi-pmr-1 
           tt-estat.fi-pmr-2               = INPUT FRAME {&frame-name} fi-pmr-2
           tt-estat.fi-pmr-3               = INPUT FRAME {&frame-name} fi-pmr-3 
           tt-estat.fi-pmr-4               = INPUT FRAME {&frame-name} fi-pmr-4
           tt-estat.fi-pmr-5               = INPUT FRAME {&frame-name} fi-pmr-5 
           tt-estat.fi-pmr-6               = INPUT FRAME {&frame-name} fi-pmr-6
           tt-estat.fi-pmr-7               = INPUT FRAME {&frame-name} fi-pmr-7 
           tt-estat.fi-pmr-8               = INPUT FRAME {&frame-name} fi-pmr-8
           tt-estat.fi-pmr-9               = INPUT FRAME {&frame-name} fi-pmr-9
           tt-estat.fi-pmr-10              = INPUT FRAME {&frame-name} fi-pmr-10
           tt-estat.fi-pmr-11              = INPUT FRAME {&frame-name} fi-pmr-11
           tt-estat.fi-pmr-12              = INPUT FRAME {&frame-name} fi-pmr-12
           tt-estat.fi-pmr-media           = INPUT FRAME {&frame-name} fi-pmr-media
           tt-estat.fi-label-vendas        = INPUT FRAME {&frame-name} fi-label-vendas
           tt-estat.fi-vendas-1            = INPUT FRAME {&frame-name} fi-vendas-1 
           tt-estat.fi-vendas-2            = INPUT FRAME {&frame-name} fi-vendas-2
           tt-estat.fi-vendas-3            = INPUT FRAME {&frame-name} fi-vendas-3 
           tt-estat.fi-vendas-4            = INPUT FRAME {&frame-name} fi-vendas-4
           tt-estat.fi-vendas-5            = INPUT FRAME {&frame-name} fi-vendas-5 
           tt-estat.fi-vendas-6            = INPUT FRAME {&frame-name} fi-vendas-6
           tt-estat.fi-vendas-7            = INPUT FRAME {&frame-name} fi-vendas-7 
           tt-estat.fi-vendas-8            = INPUT FRAME {&frame-name} fi-vendas-8
           tt-estat.fi-vendas-9            = INPUT FRAME {&frame-name} fi-vendas-9
           tt-estat.fi-vendas-10           = INPUT FRAME {&frame-name} fi-vendas-10
           tt-estat.fi-vendas-11           = INPUT FRAME {&frame-name} fi-vendas-11
           tt-estat.fi-vendas-12           = INPUT FRAME {&frame-name} fi-vendas-12
           tt-estat.fi-vendas-media        = INPUT FRAME {&frame-name} fi-vendas-media.  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-liter.i Per¡odo * L}
  assign fi-periodo:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Vendas * L}
  assign c-sigla-1:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Vendas_Acum. * L}
  assign c-sigla-2:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Saldo_em_Aberto * L}
  assign c-sigla-3:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Per¡odo * R}
  assign fi-label-periodo:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i ATM * R}
  assign fi-label-atm:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i PMR * R}
  assign fi-label-pmr:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Vendas * R}
  assign fi-label-vendas:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i M‚dia * R}
  assign fi-label-media:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Data_Conversäes * L}
  assign da-data-conver:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Per¡odo * L}
  assign fi-periodo:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Vl_Maior_T¡tulo * L}
  assign c-sigla-4:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Vl_éltimo_T¡tulo * L}
  assign c-sigla-5:label in frame {&FRAME-NAME} = return-value.

  assign v-log-sl-ab-venc = no.
  &IF defined(BF_FIN_SL_AB_VENC) &THEN
      assign v-log-sl-ab-venc = yes.
  &else
      if can-find(funcao
                  where funcao.cd-funcao = 'spp-sl-ab-venc'
                  and   funcao.ativo     = yes) then
          assign v-log-sl-ab-venc = yes.
  &ENDIF

  if v-log-sl-ab-venc then do:
      {utp/ut-liter.i Saldo_em_Aberto_Venc. * L}
      assign c-sigla-6:label in frame {&FRAME-NAME} = return-value.
  end.
  else do:
      assign c-sigla-6:visible            in frame {&frame-name} = no
             fi-saldo-aberto-venc:visible in frame {&frame-name} = no.
  end.



  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

ASSIGN l-imprime-cli = NO.
&IF DEFINED(bf_fin_imprime_cli) &THEN
    ASSIGN l-imprime-cli = YES.
&else
    IF CAN-FIND(funcao WHERE funcao.cd-funcao = 'spp-imprime-cli' AND funcao.ativo = YES) THEN
        ASSIGN l-imprime-cli = YES.
&ENDIF

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  RUN pi-inicializa.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .



  {utp/ut-liter.i Per¡odo * R}
  assign fi-label-periodo:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i ATM * R}
  assign fi-label-atm:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i PMR * R}
  assign fi-label-pmr:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Vendas * R}
  assign fi-label-vendas:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i M‚dia * R}
  assign fi-label-media:screen-value in frame {&FRAME-NAME} = return-value.

  assign da-data-conver:screen-value in frame {&FRAME-NAME} = string(da-data-sel).

  find first moeda no-lock
       where moeda.mo-codigo = 0 no-error.

  if  avail moeda then do:
      assign c-sigla-1:screen-value in frame {&FRAME-NAME} = moeda.sigla
             c-sigla-2:screen-value in frame {&FRAME-NAME} = moeda.sigla
             c-sigla-3:screen-value in frame {&FRAME-NAME} = moeda.sigla
             c-sigla-4:screen-value in frame {&FRAME-NAME} = moeda.sigla
             c-sigla-5:screen-value in frame {&FRAME-NAME} = moeda.sigla.

      if v-log-sl-ab-venc then do:
          assign c-sigla-6:screen-value in frame {&frame-name} = moeda.sigla.
      end.
  end.

  display fi-periodo with frame {&FRAME-NAME}.

  RUN pi-inicializa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
  run get-attribute ('adm-new-record').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF l-imprime-cli = YES  THEN
      ASSIGN bt-imp:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  ELSE 
      ASSIGN bt-imp:VISIBLE IN FRAME {&FRAME-NAME} = NO.

      assign fi-periodo = string(month(today),"99") + string(year(today),"9999").  

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enter-go V-table-Win 
PROCEDURE pi-enter-go :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa V-table-Win 
PROCEDURE pi-inicializa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN estatist.dt-maior-tit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           estatist.vl-maior-tit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           estatist.dt-ult-tit:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = " "
           estatist.vl-ult-tit:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = " ".


    assign fi-vendas:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = " "
           fi-vendas-acumuladas:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = " "
           fi-saldo-aberto:SCREEN-VALUE IN FRAME {&FRAME-NAME}       = " "
           fi-saldo-aberto-venc:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = " "
           fi-periodo-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-2:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-3:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-4:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-5:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " " 
           fi-periodo-6:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-7:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-8:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-9:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-periodo-10:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = " "
           fi-periodo-11:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = " "
           fi-periodo-12:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = " "
           fi-atm-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-2:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-3:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-4:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-5:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-6:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-7:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-8:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-9:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-atm-10:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = " "
           fi-atm-11:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = " "
           fi-atm-12:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = " "
           fi-atm-media:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-pmr-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-2:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-3:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-4:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-5:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-6:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-7:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-8:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-9:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = " "
           fi-pmr-10:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = " "
           fi-pmr-11:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = " "
           fi-pmr-12:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = " "
           fi-pmr-media:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-vendas-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-2:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-3:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-4:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-5:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-6:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-7:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-8:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-9:SCREEN-VALUE IN FRAME {&FRAME-NAME}           = " "
           fi-vendas-10:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-vendas-11:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-vendas-12:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = " "
           fi-vendas-media:SCREEN-VALUE IN FRAME {&FRAME-NAME}       = " " .



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "emitente"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

