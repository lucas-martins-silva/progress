/* variaveis globais */
{utp/ut-glob.i}

/* tt-erro */
{cdg/cdg0666.i}
{cdg/cdcfgaps.i}
DEFINE VAR iSeqErro             AS INTEGER                             NO-UNDO.
DEFINE VAR de-val-refer-atualiz LIKE area-produc-dbr.val-refer-atualiz NO-UNDO.

/**** item -> item-dbr ****/
DEFINE TEMP-TABLE tt-item-dbr NO-UNDO
    FIELD cd-planejado            AS CHARACTER 
    FIELD cod-estabel             AS CHARACTER 
    FIELD compr-fabric            AS INTEGER   
    FIELD desc-item               AS CHARACTER 
    FIELD div-ordem               AS INTEGER   
    FIELD fator-refugo            AS DECIMAL   
    FIELD fm-cod-com              AS CHARACTER 
    FIELD fm-codigo               AS CHARACTER 
    FIELD fraciona                AS LOGICAL   
    FIELD ge-codigo               AS INTEGER   
    FIELD horiz-fixo              AS INTEGER   
    FIELD it-codigo               AS CHARACTER 
    FIELD lote-economi            AS DECIMAL   
    FIELD lote-minimo             AS DECIMAL   
    FIELD lote-multipl            AS DECIMAL   
    FIELD niv-mais-bai            AS INTEGER   
    FIELD num-priorid             AS INTEGER   
    FIELD periodo-fixo            AS INTEGER   
    FIELD politica                AS INTEGER   
    FIELD quant-perda             AS DECIMAL   
    FIELD quant-segur             AS DECIMAL   
    FIELD res-cq-comp             AS INTEGER   
    FIELD res-cq-fab              AS INTEGER   
    FIELD res-for-comp            AS INTEGER   
    FIELD res-int-comp            AS INTEGER   
    FIELD ressup-fabri            AS INTEGER   
    FIELD tempo-segur             AS INTEGER   
    FIELD tipo-con-est            AS INTEGER   
    FIELD tipo-est-seg            AS INTEGER   
    FIELD un                      AS CHARACTER 
    FIELD cod-comprador           AS CHARACTER 
    FIELD cod-obsoleto            AS INTEGER   
    INDEX codigo IS PRIMARY UNIQUE
          it-codigo.

/*** item-uni-estab -> item-estab-dbr ***/
DEFINE TEMP-TABLE tt-item-estab-dbr NO-UNDO
    FIELD it-codigo      AS CHARACTER 
    FIELD cd-planejado   AS CHARACTER 
    FIELD cod-estabel    AS CHARACTER 
    FIELD div-ordem      AS INTEGER   
    FIELD fator-refugo   AS DECIMAL   
    FIELD horiz-fixo     AS INTEGER   
    FIELD lote-economi   AS DECIMAL   
    FIELD lote-minimo    AS DECIMAL   
    FIELD lote-multipl   AS DECIMAL   
    FIELD periodo-fixo   AS INTEGER   
    FIELD politica       AS INTEGER 
    field quant-perda    as decimal
    FIELD quant-segur    AS DECIMAL   
    FIELD res-cq-comp    AS INTEGER   
    FIELD res-cq-fabri   AS INTEGER   
    FIELD res-for-comp   AS INTEGER
    FIELD ressup-fabri   AS INTEGER   
    FIELD cod-obsoleto   AS INTEGER
    FIELD sit-aloc       AS INTEGER   
    FIELD deposito-pad   AS CHARACTER 
    FIELD nr-linha       AS INTEGER   
    FIELD tempo-segur    AS INTEGER   
    field cod-comprador  as character
    Field tipo-est-seg   as integer  
    field res-int-comp   as integer
    field num-priorid    as integer
    INDEX codigo IS PRIMARY UNIQUE
         it-codigo cod-estabel .
  
/*** ref-item -> refer-item-dbr***/
DEFINE TEMP-TABLE tt-refer-item-dbr NO-UNDO
    FIELD it-codigo AS CHARACTER
    FIELD cod-refer AS CHARACTER
    INDEX id IS PRIMARY UNIQUE
          cod-refer it-codigo.

/*** estrutura -> estrut-item-dbr ***/
DEFINE TEMP-TABLE tt-estrut-item-dbr NO-UNDO
    FIELD it-codigo         AS CHARACTER
    FIELD sequencia         AS INTEGER
    FIELD es-codigo         AS CHARACTER
    field fantasma          AS LOGICAL
    FIELD op-codigo         AS INTEGER
    FIELD cod-roteiro       AS CHARACTER
    field proporcao         AS DECIMAL
    field data-inicio       AS DATE
    field data-termino      AS DATE
    field qtd-item          AS DECIMAL
    field qtd-compon        AS DECIMAL DECIMALS 10
    field tipo-sobra        AS INTEGER
    FIELD cod-lista-compon  AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          it-codigo
          sequencia
          es-codigo.
 
/*** ref-estrut -> ref-it-estrut ***/
DEFINE TEMP-TABLE tt-ref-it-estrut-dbr NO-UNDO
    FIELD it-codigo         AS CHARACTER
    FIELD sequencia         AS INTEGER
    FIELD es-codigo         AS CHARACTER
    FIELD cod-ref-it        AS CHARACTER
    FIELD cod-ref-es        AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
        it-codigo
        sequencia
        es-codigo
        cod-ref-it.

/*** rot-item -> rot-item-dbr ***/
DEFINE TEMP-TABLE tt-rot-item-dbr NO-UNDO
    FIELD  it-codigo      AS   CHARACTER
    FIELD  sequencia      AS   INTEGER
    FIELD  cod-roteiro    AS   CHARACTER
    FIELD  data-inicio    AS   DATE        
    FIELD  data-termino   AS   DATE
    INDEX codigo IS PRIMARY UNIQUE
          it-codigo
          sequencia
          cod-roteiro.

/*** operacao -> operac-engr ***/
DEF TEMP-TABLE tt-operac-engr    NO-UNDO
    FIELD it-codigo          AS       CHARACTER       
    FIELD cod-roteiro        AS       CHARACTER       
    FIELD op-codigo          AS       INTEGER  
    FIELD descricao          AS       CHARACTER
    FIELD tipo-oper          AS       INTEGER
    FIELD gm-codigo          AS       CHARACTER       
    FIELD nr-unidades        AS       INTEGER
    FIELD tempo-prepar       AS       DECIMAL      
    FIELD tempo-homem        AS       DECIMAL 
    FIELD tempo-maquin       AS       DECIMAL
    FIELD data-inicio        AS       DATE        
    FIELD data-termino       AS       DATE        
    FIELD nr-oper-pad        AS       INTEGER
    FIELD num-id-operacao    AS       INTEGER
    FIELD tempo-sig          AS       LOGICAL
    FIELD cod-reduc-prepar   AS       CHARACTER
    INDEX id IS PRIMARY UNIQUE
          num-id-operacao.

/*** op-ferram -> op-ferr-dbr ***/
DEFINE TEMP-TABLE tt-op-ferr-dbr NO-UNDO
    FIELD ferramenta         AS  CHARACTER
    FIELD op-altern          AS  INTEGER
    FIELD num-id-operacao    AS  INTEGER
    FIELD sequencia          AS  INTEGER
    INDEX id IS PRIMARY UNIQUE
          num-id-operacao
          op-altern
          ferramenta
    INDEX ferr
          ferramenta.

/***   prazo-compra,ord-prod -> ord-dbr ***/
DEFINE TEMP-TABLE tt-ord-dbr NO-UNDO
    FIELD num-ord-dbr      AS INTEGER
    FIELD parcela          AS INTEGER
    FIELD it-codigo        AS CHARACTER
    FIELD cod-refer        AS CHARACTER
    FIELD cod-estabel      AS CHARACTER
    FIELD dat-entrega      AS DATE
    FIELD dat-inicio       AS DATE
    FIELD qtd-saldo        AS DECIMAL DECIMALS 10
    FIELD nr-pedcli        AS CHARACTER
    FIELD nome-abrev       AS CHARACTER
    FIELD nr-sequencia     AS INTEGER
    FIELD idi-tip-ord-dbr  AS INTEGER
    FIELD nr-entrega       AS INTEGER
    FIELD prioridade       AS INTEGER
    FIELD tipo             AS INTEGER
    FIELD qt-ordem         AS DECIMAL DECIMALS 10
    INDEX codigo IS PRIMARY UNIQUE
          num-ord-dbr
          parcela
          idi-tip-ord-dbr
    INDEX tipo
          idi-tip-ord-dbr
          num-ord-dbr
          parcela
    INDEX ITEM 
          it-codigo
          cod-refer
          dat-entrega
    INDEX item-tipo
          it-codigo
          idi-tip-ord-dbr.

/***   oper-ord -> op-ord-dbr ***/
DEFINE TEMP-TABLE tt-op-ord-dbr NO-UNDO
    FIELD nr-ord-produ     AS INTEGER
    FIELD op-codigo        AS INTEGER
    FIELD descricao        AS CHARACTER
    FIELD tipo-oper        AS INTEGER
    FIELD gm-codigo        AS CHARACTER
    FIELD tempo-prepar     AS DECIMAL DECIMALS 3
    FIELD tempo-homem      AS DECIMAL DECIMALS 3
    FIELD tempo-maquin     AS DECIMAL DECIMALS 3
    FIELD cod-roteiro      AS CHARACTER
    FIELD qtd-prog         AS DECIMAL
    FIELD tempo-sig        AS LOGICAL
    FIELD num-id-operacao  AS INTEGER
    FIELD sequencia        AS INTEGER
    FIELD it-codigo        AS CHARACTER
    FIELD cod-ctrab        AS CHARACTER
    FIELD cod-ferram       AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          nr-ord-produ
          it-codigo
          cod-roteiro
          op-codigo
    INDEX operacao
          num-id-operacao
    INDEX ordem
          nr-ord-produ
          sequencia.

/*** reservas, ord-prod -> res-ord-dbr ***/
DEFINE TEMP-TABLE tt-res-ord-dbr NO-UNDO
    FIELD nr-ord-produ     AS INTEGER
    FIELD it-codigo        AS CHARACTER
    FIELD item-pai         AS CHARACTER
    FIELD cod-roteiro      AS CHARACTER
    FIELD tipo-sobra       AS INTEGER
    FIELD cod-refer        AS CHARACTER
    FIELD qtd-saldo        AS DECIMAL DECIMALS 10
    FIELD op-codigo        AS INTEGER
    FIELD dat-reserva-op   AS DATE
    FIELD log-livre-1      as logical /* indica se a reservas esta sendo atendida pr uma ordem de producao no caso de item MTO */
    FIELD val-livre-1      AS DECIMAL /* indica em quanto a ordem est sendo atendida */
    INDEX operacao IS PRIMARY UNIQUE
          nr-ord-produ
          item-pai
          cod-roteiro
          op-codigo
          it-codigo
          cod-refer
   INDEX ITEM
         nr-ord-produ
         it-codigo
         cod-refer.        

/*** saldo-estoq, res-item, saldo-terc -> sdo-estoq-dbr ***/   
DEFINE TEMP-TABLE tt-sdo-estoq-dbr NO-UNDO
    FIELD it-codigo              AS         CHARACTER
    FIELD cod-refer              AS         CHARACTER
    FIELD cod-estabel            AS         CHARACTER
    FIELD qtd-sdo-estoq-dbr      AS         DECIMAL        
    FIELD qtd-remes-benef        AS         DECIMAL
    FIELD qtd-entr-benef         AS         DECIMAL
    FIELD qtd-remes-consig       AS         DECIMAL
    FIELD qtd-entr-consig        AS         DECIMAL
    FIELD qtd-sdo-transi         AS         DECIMAL
    FIELD cod-lote               AS         CHARACTER
    FIELD dat-valid-lote         AS         DATE
    INDEX codigo IS PRIMARY UNIQUE
         it-codigo
         cod-refer
         cod-lote
         cod-estabel
    INDEX it-estab
         it-codigo
         cod-refer
         cod-estabel .   
 
/*** ped-ent,ped-venda -> pdven-dbr ***/
DEFINE TEMP-TABLE tt-pdven-dbr NO-UNDO
    FIELD nr-pedcli                 AS CHARACTER
    FIELD nome-abrev                AS CHARACTER
    FIELD nr-sequencia              AS INTEGER
    FIELD nr-entrega                AS INTEGER
    FIELD it-codigo                 AS CHARACTER
    FIELD cod-refer                 AS CHARACTER
    FIELD cod-estabel               AS CHARACTER
    FIELD dt-entrega                AS DATE
    FIELD qtd-saldo                 AS DECIMAL
    FIELD num-priorid               AS INTEGER
    FIELD idi-sit-avaliac           AS INTEGER
    INDEX id IS PRIMARY UNIQUE
          nr-pedcli
          nome-abrev
          nr-sequencia
          nr-entrega
          it-codigo
          cod-refer
          cod-estabel
    INDEX ITEM
          it-codigo
          cod-refer
          nr-pedcli
          nome-abrev
          nr-sequencia
          nr-entrega.

define temp-table tt-proces-item-dbr no-undo
        field it-codigo         as character
        field num-seq           as integer
        field cod-roteiro       as character
        field cod-refer         as character
        field qtd-min-item      as decimal
        field qtd-max-item      as decimal
        field cod-estabel       as character
        field nr-linha          as integer
        field data-inicio       as date
        field data-termino      as date
        field des-regra-proces  as character
        FIELD cod-lista-compon  AS CHARACTER
        FIELD val-proporcao     AS DECIMAL
        index codigo is primary unique
              it-codigo
              num-seq.  

/*** ctrab-operac-aloc -> ctrab-op-dbr ***/
DEFINE NEW SHARED TEMP-TABLE tt-ctrab-op-dbr NO-UNDO
    FIELD num-id-operacao   AS INTEGER
    FIELD op-altern         AS INTEGER
    FIELD cod-ctrab         AS CHARACTER
    FIELD prioridade        AS INTEGER
    FIELD val-perform       AS DECIMAL
    INDEX prior IS PRIMARY UNIQUE
          num-id-operacao op-altern prioridade.

DEFINE TEMP-TABLE tt-sdo-terc-dbr NO-UNDO
    FIELD it-codigo         AS CHARACTER
    FIELD quant-saldo       AS DECIMAL 
    FIELD cod-estab-produc  AS CHARACTER
    FIELD cod-estab-solic   AS CHARACTER 
    FIELD tipo-sal-terc     AS INTEGER 
    FIELD cod-refer         AS CHARACTER
    FIELD dat-emissao       AS DATE
    INDEX sdtrcdbr-id IS PRIMARY UNIQUE
            it-codigo
            cod-refer
            tipo-sal-terc
            cod-estab-solic
            cod-estab-produc
            dat-emissao.

/* fim do include */
