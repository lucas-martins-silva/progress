DEFINE TEMP-TABLE tt-item-wms NO-UNDO
    FIELD cod-estabel  AS CHAR FORMAT 'x(5)'
    FIELD cod-depos    AS CHAR FORMAT 'X(3)'
    FIELD cod-item     AS CHAR    FORMAT 'x(16)'
    FIELD cod-refer    AS CHAR    FORMAT 'x(8)'
    FIELD cod-lote     AS CHAR    FORMAT 'x(40)'
    FIELD num-seq-orig AS INTEGER FORMAT '>>>>>9'
    FIELD qtd-item     AS DECI FORMAT '>>>,>>>,>>9.999'
    INDEX id AS UNIQUE cod-estabel cod-depos cod-item cod-refer cod-lote num-seq-orig.
    
DEF TEMP-TABLE tt-erro-inv NO-UNDO
    FIELD i-sequen AS INT
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".
    
DEF TEMP-TABLE tt-erro-ceapi001k NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEFINE TEMP-TABLE ttSummaryInventoryBalance NO-UNDO 
    FIELD cod-depos LIKE saldo-estoq.cod-depos
    FIELD cod-localiz LIKE saldo-estoq.cod-localiz
    FIELD lote LIKE saldo-estoq.lote
    FIELD dt-vali-lote LIKE saldo-estoq.dt-vali-lote
    FIELD cod-refer LIKE movto-estoq.cod-refer
    FIELD qtidade-atu LIKE saldo-estoq.qtidade-atu
    FIELD qt-a-atender LIKE it-requisicao.qt-a-atender
    FIELD close AS LOGICAL
    FIELD nr-requisicao LIKE it-requisicao.nr-requisicao
    FIELD sequencia LIKE it-requisicao.sequencia
    FIELD dt-trans LIKE movto-estoq.dt-trans
    FIELD showMsg AS LOGICAL
    FIELD logprocesswms AS CHARACTER /* LIKE it-requisicao.log-process-wms */
    FIELD rw-movto AS CHARACTER FORMAT "x(100)"
    FIELD is-wms-saas AS LOGICAL.

DEFINE TEMP-TABLE ttItRequisicaoHTML NO-UNDO 
    LIKE it-requisicao
    FIELD dt-requisicao LIKE requisicao.dt-requisicao
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD sit           AS INTEGER
    FIELD tipo-con-est  LIKE item.tipo-con-est
    fIELD desc-status   AS CHARACTER      
    FIELD rRowid        AS ROWID
    FIELD ind-saldo     AS INTEGER. 

DEFINE TEMP-TABLE ttSummaryAux NO-UNDO LIKE ttSummaryInventoryBalance.       
   
DEFINE TEMP-TABLE ttItRequisicaoCount NO-UNDO LIKE ttItRequisicaoHTML.

DEFINE BUFFER b-ttSummaryInventoryBalance FOR ttSummaryInventoryBalance. 

DEFINE DATASET dsAtendimento FOR ttItRequisicaoHTML. 

