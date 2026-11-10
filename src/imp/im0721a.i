/*******************************************************************/
/* IM0720a.i Include defini‡äes vari veis, temp-tables e forms     */
/*******************************************************************/

DEFINE TEMP-TABLE tt-adiant-despes-parc NO-UNDO LIKE adiant-despes-parc
    FIELD r-rowid as rowid.   

DEFINE TEMP-TABLE tt-adiant-despes-parc-aux NO-UNDO LIKE tt-adiant-despes-parc
    FIELD marcar AS CHARACTER.

def temp-table tt-bo-erro no-undo
    field cod-estabel      like adiant-despes-parc.cod-estabel 
    field cdd-adiant       like adiant-despes-parc.cdd-adiant
    field parcela          like adiant-despes-parc.cod-parcela
    field cod-refer        like adiant-despes-parc.cod-refer
    field sequencia        as INTEGER      
    field num-erro         as INTEGER
    field descricao        as char
    field ajuda            as char
    field tipo             as char
    INDEX codigo IS PRIMARY sequencia.

def temp-table tt-titulo-gerado no-undo
    field cod-estabel       like adiant-despes-parc.cod-estabel
    field cdd-adiant        like adiant-despes-parc.cdd-adiant
    field cod-refer         like adiant-despes-parc.cod-refer
    field ep-codigo         like param-global.empresa-prin
    field cod-esp           like adiant-despes-parc.cod-esp
    field serie             like adiant-despes-parc.cod-ser-docto
    field cod-tit-ap        like adiant-despes-parc.cod-tit-ap
    field parcela           like adiant-despes-parc.cod-parcela
    field cdn-emitente      like adiant-despes-parc.cdn-emitente
    INDEX titulo IS PRIMARY cod-refer.

define temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer.

DEFINE BUFFER b-adiant-despes-parc FOR adiant-despes-parc.

define temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

define temp-table tt-digita NO-UNDO
    field r-adiant        as rowid.

DEF NEW GLOBAL SHARED VAR c-seg-usuario   AS CHAR      NO-UNDO FORMAT 'x(12)'.
DEF VAR i-empresa-prin  LIKE param-global.empresa-prin NO-UNDO.
DEF VAR i-tp-rec-padrao LIKE emitente.tp-rec-padrao    NO-UNDO.
DEF VAR de-cotacao      LIKE cotacao.cotacao EXTENT 0  NO-UNDO.
DEF VAR l-imprime-tit   AS LOGICAL                     NO-UNDO.
DEF VAR l-imprime-err   AS LOGICAL                     NO-UNDO.
DEF VAR l-primeiro      AS LOGICAL                     NO-UNDO. 
DEF VAR i-seq           AS INTEGER                     NO-UNDO.

DEFINE VARIABLE c-titulo   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-titulo1 AS CHARACTER NO-UNDO.

form  
     tt-bo-erro.cod-estabel COLUMN-LABEL "Est" FORMAT 99999 
     tt-bo-erro.cdd-adiant  COLUMN-LABEL "Adiantamento"
     tt-bo-erro.cod-refer   COLUMN-LABEL "Referˆncia"
     tt-bo-erro.sequencia   COLUMN-LABEL "Seq" FORMAT 99
     tt-bo-erro.num-erro    COLUMN-LABEL "Erro" FORMAT 99999 
     tt-bo-erro.descricao   COLUMN-LABEL "Descri‡Æo" FORMAT "x(70)"
     with down no-box width 136 stream-io frame f-layout1.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-layout1:HANDLE).

form  
     tt-titulo-gerado.cod-estabel  COLUMN-LABEL "Est" FORMAT 99999  
     tt-titulo-gerado.cod-refer    COLUMN-LABEL "Referˆncia"
     tt-titulo-gerado.cdn-emitente COLUMN-LABEL "Emitente"
     tt-titulo-gerado.cod-esp      COLUMN-LABEL "Esp" FORMAT "x(3)"  
     tt-titulo-gerado.serie        COLUMN-LABEL "S‚rie" 
     tt-titulo-gerado.cod-tit-ap   COLUMN-LABEL "T¡tulo" FORMAT "x(16)"  
     tt-titulo-gerado.parcela      COLUMN-LABEL "/P" FORMAT "x(2)"   
     with down no-box width 136 stream-io frame f-layout2.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-layout2:HANDLE).


