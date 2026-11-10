/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/******************************************************************************
**
**     Include ..: im0665.i
**     Objetivo .: Cont‚m os a temp table de parametros
**                 e as forms do programa IM0665 .
**
*******************************************************************************/

{utp/ut-glob.i}

DEF VAR c-destino    AS CHAR LABEL "Destino" NO-UNDO.
def var c-desc-moeda like moeda.descricao    no-undo.

define temp-table tt-param no-undo
    field destino                as integer
    field arquivo                as char
    field usuario                as char format "x(12)" LABEL "Usu rio"
    field data-exec              as DATE FORMAT "99/99/9999"
    field hora-exec              as integer
    field classifica             as int
    field desc-classifica        as CHAR FORMAT "x(40)"
    field c-cod-estabel-ini      like estabelec.cod-estabel LABEL "Estabelecimento"
    field c-cod-estabel-fim      like estabelec.cod-estabel
    field c-embarque-ini         like embarque-imp.embarque
    field c-embarque-fim         like embarque-imp.embarque
    field c-it-codigo-ini        like item.it-codigo
    field c-it-codigo-fim        like item.it-codigo
    field i-ge-codigo-ini        like grup-estoque.ge-codigo
    field i-ge-codigo-fim        like grup-estoque.ge-codigo
    field c-fm-codigo-ini        like familia.fm-codigo
    field c-fm-codigo-fim        like familia.fm-codigo
    field i-cod-emitente-ini     like emitente.cod-emitente LABEL "Fornecedor(Exportador)"
    field i-cod-emitente-fim     like emitente.cod-emitente
    field c-nr-proc-imp-ini      like processo-imp.nr-proc-imp LABEL "Processo"
    field c-nr-proc-imp-fim      like processo-imp.nr-proc-imp
    field i-cod-itiner-ini       like itinerario.cod-itiner   LABEL "Itiner rio"
    field i-cod-itiner-fim       like itinerario.cod-itiner
    field da-dt-nac-ini          as date    label "Data Nacionaliza‡Æo"              FORMAT "99/99/9999"
    field da-dt-nac-fim          as date                                             FORMAT "99/99/9999"
    field moeda                  like moeda.mo-codigo
    field da-dt-conv             as date    label "Data ConversÆo"                   FORMAT "99/99/9999"
    field l-dt-nacional          as logical label "Data de Nacionaliza‡Æo"           FORMAT "Sim/NÆo"
    field l-orc-real             as logical label "Or‡ado X Realizado"               FORMAT "Sim/NÆo"
    field l-desp-imposto         as logical label "Detalha Despesas/Impostos"        FORMAT "Sim/NÆo"
    field l-itens                as logical label "Detalha Itens"                    FORMAT "Sim/NÆo"
    field l-desemb-parc          as logical label "Considera Desembarque Parcial"    FORMAT "Sim/NÆo"
    field l-nf-compl             as logical label "Considera NF Complementar"        FORMAT "Sim/NÆo"
    field l-desc-desp-item       as logical label "Desc. desp. nÆo incidem item"     FORMAT "Sim/NÆo"
    field l-novos-tributos       as logical label "Considera Somente Novos Tributos" FORMAT "Sim/NÆo"
    field i-custo-item           as int
    field i-compar-merc          AS INT
    field c-custo-item           AS CHAR    LABEL "Custo Item"
    field i-desp-imposto         as int
    field c-desp-imposto         AS CHAR    LABEL "Considera"
    field l-considera-cot-docto  AS LOGICAL LABEL "Considera Cota‡Æo do Documento"     FORMAT "Sim/NÆo"
    field excel                  AS LOG
    field dir-arq-excel          AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

def temp-table tt-raw-digita no-undo
    field raw-digita as raw.

define temp-table tt-detalha-item no-undo
    FIELD sequencia                         LIKE item-doc-est.sequencia
    field embarque                          like embarque-imp.embarque
    field embarque-orig                     like embarque-imp.embarque
    field cod-estabel                       like embarque-imp.cod-estabel
    field nro-docto                         like item-doc-est.nro-docto
    field it-codigo                         like item.it-codigo
    field descricao                         like item.desc-item
    field numero-ordem                      like ordem-compra.numero-ordem
    FIELD parcela                           LIKE ordens-embarque.parcela
    field quantidade                        like item-doc-est.quantidade
    field un                                like item.un
    field desc-despesa                      like desp-imp.descricao
    field situacao                          as   int
    field aliquota-ii                       as   decimal format ">9.9999":U
    field aliquota-ipi                      as   decimal format ">>9.99":U
    field aliquota-icms                     as   decimal format ">>9.99":U
    field aliquota-pis                      as   decimal format ">>9.9999":U
    field aliquota-cofins                   as   decimal format ">>9.9999":U
    field aliquota-ii2                      as   decimal format ">>9.9999":U
    field aliquota-cbs                      as   decimal format ">>9.99":U
    field aliquota-ibs-uf                   as   decimal format ">>9.99":U
    field aliquota-ibs-mun                  as   decimal format ">>9.99":U
    field aliquota-is                       as   decimal format ">>9.99":U
    field vl-mercado-orc                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-mercado-orc-total              as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ii-orc                         as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ipi-orc                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-icms-orc                       as   decimal format ">>>,>>>,>>9.99999":U
    field vl-pis-orc                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-cofins-orc                     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-cbs-orc                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ibs-uf-orc                     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ibs-mun-orc                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-is-orc                         as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-imp-orc                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ii2-orc                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ii2-orc-aux                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ii-orc-aux                     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-des-orc                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-des-orc-total                  as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-des-orc                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-des-orc-total              as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-imp-des-orc                as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-imp-des-orc-total          as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-com-ipi-icms-orc           as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-com-ipi-icms-orc-total     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-sem-ipi-icms-orc           as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-sem-ipi-icms-orc-total     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-mercado-rea                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-mercado-rea-total              as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ii-rea                         as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ii-rea-total                   as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ipi-rea                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ipi-rea-total                  as   decimal format ">>>,>>>,>>9.99999":U
    field vl-icms-rea                       as   decimal format ">>>,>>>,>>9.99999":U
    field vl-pis-rea                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-cofins-rea                     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-icms-rea-total                 as   decimal format ">>>,>>>,>>9.99999":U
    field vl-cbs-rea                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-cbs-rea-total                  as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ibs-uf-rea                     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ibs-uf-rea-total               as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ibs-mun-rea                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ibs-mun-rea-total              as   decimal format ">>>,>>>,>>9.99999":U
    field vl-is-rea                         as   decimal format ">>>,>>>,>>9.99999":U
    field vl-is-rea-total                   as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-imp-rea                    as   decimal format ">>>,>>>,>>9.99999":U decimals 4
    field vl-tot-imp-rea-total              as   decimal format ">>>,>>>,>>9.99999":U decimals 4
    field vl-ii2-rea                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-ii2-rea-total                  as   decimal format ">>>,>>>,>>9.99999":U
    field vl-des-rea                        as   decimal format ">>>,>>>,>>9.99999":U
    field vl-des-rea-total                  as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-des-rea                    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-des-rea-total              as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-des-rea-total-aux          as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-imp-des-rea                as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-imp-des-rea-total          as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-com-ipi-icms-rea           as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-com-ipi-icms-rea-total     as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-com-ipi-icms-dsp-merc-rea  as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-sem-ipi-icms-dsp-merc-rea  as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-sem-ipi-icms-rea           as   decimal format ">>>,>>>,>>9.99999":U
    field vl-tot-sem-ipi-icms-rea-total     as   decimal format ">>>,>>>,>>9.99999":U
    field per-mercado-orc                   as   decimal format ">>9.99":U
    field per-mercado-rea                   as   decimal format ">>9.99":U
    field per-ii-orc                        as   decimal format ">>9.99":U
    field per-ii-rea                        as   decimal format ">>9.99":U
    field per-ipi-orc                       as   decimal format ">>9.99":U
    field per-ipi-rea                       as   decimal format ">>9.99":U
    field per-icms-orc                      as   decimal format ">>9.99":U
    field per-icms-rea                      as   decimal format ">>9.99":U
    field per-cbs-orc                       as   decimal format ">>9.99":U
    field per-cbs-rea                       as   decimal format ">>9.99":U
    field per-ibs-uf-orc                    as   decimal format ">>9.99":U
    field per-ibs-uf-rea                    as   decimal format ">>9.99":U
    field per-ibs-mun-orc                   as   decimal format ">>9.99":U
    field per-ibs-mun-rea                   as   decimal format ">>9.99":U
    field per-is-orc                        as   decimal format ">>9.99":U
    field per-is-rea                        as   decimal format ">>9.99":U
    field per-tot-imp-orc                   as   decimal format ">>9.99":U
    field per-tot-imp-rea                   as   decimal format ">>9.99":U
    field per-ii2-orc                       as   decimal format ">>9.99":U
    field per-ii2-rea                       as   decimal format ">>9.99":U
    field per-des-orc                       as   decimal format ">>9.99":U
    field per-des-rea                       as   decimal format ">>9.99":U
    field per-tot-des-orc                   as   decimal format ">>9.99":U
    field per-tot-des-rea                   as   decimal format ">>9.99":U
    field per-tot-imp-des-orc               as   decimal format ">>9.99":U
    field per-tot-imp-des-rea               as   decimal format ">>9.99":U
    field per-tot-com-ipi-icms-orc          as   decimal format ">>9.99":U
    field per-tot-com-ipi-icms-rea          as   decimal format ">>9.99":U
    field per-tot-sem-ipi-icms-orc          as   decimal format ">>9.99":U
    field per-tot-sem-ipi-icms-rea          as   decimal format ">>9.99":U
    field vl-des-frete                      as decimal format ">>>,>>>,>>9.99999" /*like desp-imp.val-desp*/
    field vl-des-embalagem                  as decimal format ">>>,>>>,>>9.99999" /*like desp-imp.val-desp*/
    field vl-des-seguro                     as decimal format ">>>,>>>,>>9.99999" /*like desp-imp.val-desp*/
    field vl-des-outras                     as decimal format ">>>,>>>,>>9.99999" /*like desp-imp.val-desp*/
    field vl-tot-despesa                    like desp-imp.val-desp
    FIELD vl-pis-rea-total                  AS   DECIMAL FORMAT ">>>,>>>,>>9.99"
    FIELD vl-cofins-rea-total               AS   DECIMAL FORMAT ">>>,>>>,>>9.99"
    FIELD per-pis-rea                       AS   DECIMAL FORMAT ">>9.99"
    FIELD per-cofins-rea                    AS   DECIMAL FORMAT ">>9.99"
    FIELD per-pis-orc                       AS   DECIMAL FORMAT ">>9.99"
    FIELD i-numero-itens                    AS   INTEGER
    FIELD tot-quantidade                    LIKE item-doc-est.quantidade
    FIELD per-cofins-orc                    AS   DECIMAL FORMAT ">>9.99"
    FIELD mo-ger-mercado-rea                LIKE docum-est.mo-codigo
    FIELD vl-ger-mercado-rea-mo             as decimal format ">>>,>>>,>>9.99":U
    FIELD mo-ii2-rea                        LIKE docum-est.mo-codigo
    FIELD vl-ger-ii2-rea-mo                 as decimal format ">>>,>>>,>>9.99":U
    index ch-codigo
          cod-estabel
          embarque
          it-codigo
          numero-ordem
          parcela
    index ch-item
          it-codigo
          embarque.

define temp-table tt-embarque-cabec  no-undo
    field cod-estabel            like estabelec.cod-estabel
    field desc-estab             as   char format "x(34)":U
    field embarque               like embarque-imp.embarque
    field cod-emitente           like emitente.cod-emitente
    field desc-emit              like emitente.nome-abrev
    field pais                   like emitente.pais
    field cod-incoterm           like embarque-imp.cod-incoterm
    field cod-via-transp         like embarque-imp.cod-via-transp
    FIELD pto-despacho           like pto-contr.descricao
    field data-ult-prev-desp     as   date format "99/99/9999":U
    field data-despacho          as   date format "99/99/9999":U
    field pto-embarque           like pto-contr.descricao
    FIELD data-ult-prev-embarque as   date format "99/99/9999":U
    field data-embarque          as   date format "99/99/9999":U
    field pto-nacional           like pto-contr.descricao
    field data-ult-prev-nac      as   date format "99/99/9999":U
    field data-nacional          as   date format "99/99/9999":U
    field pto-chegada           like pto-contr.descricao
    field data-ult-prev-chegada as   date format "99/99/9999":U
    field data-chegada           as   date format "99/99/9999":U
    field data-cotacao           as   date format "99/99/9999":U
    field desc-moeda             like moeda.descricao
    field mo-taxa                as   decimal format "99999.99999999":U
    field data-convercao         as   date format "99/99/9999":U
    index ch-codigo is unique primary
          embarque
          cod-estabel
          cod-emitente.
/*A ordem dos campos ‚ o que define como ser  impresso no excel*/
DEFINE TEMP-TABLE tt-dados-excel NO-UNDO
    field cod-estabel            like estabelec.cod-estabel LABEL "Estabelecimento"
    field embarque               like embarque-imp.embarque LABEL "Embarque"
    field cod-emitente           like emitente.cod-emitente LABEL "Exportador"
    FIELD des-emit               AS CHAR                    LABEL "Nome Exportador"
    field pais                   like emitente.pais         LABEL "Pa¡s de Origem"
    field cod-incoterm           like embarque-imp.cod-incoterm   LABEL "Incoterm"
    field des-via-transp         AS CHAR                          LABEL "Via de Transporte"
    FIELD pto-despacho           like pto-contr.descricao         LABEL "Ponto de Despacho"
    field data-ult-prev-desp     as   date format "99/99/9999":U  LABEL "Data élt Prev Despacho"
    field data-despacho          as   date format "99/99/9999":U  LABEL "Data Despacho"
    field pto-embarque           like pto-contr.descricao         LABEL "Ponto de Embarque"
    FIELD data-ult-prev-embarque as   date format "99/99/9999":U  LABEL "Data élt Prev Embarque"
    field data-embarque          as   date format "99/99/9999":U  LABEL "Data Embarque"
    field pto-nacional           like pto-contr.descricao         LABEL "Ponto de Nacionaliza‡Æo"
    field data-ult-prev-nac      as   date format "99/99/9999":U  LABEL "Data élt PrevisÆo Nacionaliza‡Æo"
    field data-nacional          as   date format "99/99/9999":U  LABEL "Data Nacionaliza‡Æo"
    field pto-chegada           like pto-contr.descricao         LABEL "Ponto de Chegada"
    field data-ult-prev-chegada as   date format "99/99/9999":U  LABEL "Data élt PrevisÆo Chegada"
    field data-chegada          as   date format "99/99/9999":U  LABEL "Data Chegada na F brica"
    field data-cotacao           as   date format "99/99/9999":U  LABEL "Data Cota‡Æo Nacionaliza‡Æo"
    field desc-moeda             like moeda.descricao             LABEL "Moeda"
    field mo-taxa                as   decimal format "99999.99999999":U LABEL "Taxa"
    field data-convercao         as   date format "99/99/9999":U        LABEL "Dt ConversÆo"
    FIELD nr-di                  LIKE embarque-imp.declaracao-import    LABEL "N£mero DI"
    FIELD dt-di                  LIKE embarque-imp.data-di              LABEL "Data DI".

/*A ordem dos campos ‚ o que define como ser  impresso no excel*/
DEFINE TEMP-TABLE tt-dados-excel-detail NO-UNDO
    field cod-estabel         like estabelec.cod-estabel LABEL "Estabelecimento"
    field embarque            like embarque-imp.embarque LABEL "Embarque"
    field cod-emitente        like emitente.cod-emitente LABEL "Exportador"
    FIELD des-emit            AS CHAR                    LABEL "Nome Exportador"
    field pais                like emitente.pais         LABEL "Pa¡s de Origem"
    field cod-incoterm        like embarque-imp.cod-incoterm   LABEL "Incoterm"
    field des-via-transp      AS CHAR                          LABEL "Via de Transporte"
    field pto-embarque        like pto-contr.descricao         LABEL "Ponto de Embarque"
    field data-embarque       as   date format "99/99/9999":U  LABEL "Data Embarque"
    field pto-nacional        like pto-contr.descricao         LABEL "Ponto de Nacionaliza‡Æo"
    field data-nacional       as   date format "99/99/9999":U  LABEL "Data Nacionaliza‡Æo"
    field data-chegada        as   date format "99/99/9999":U  LABEL "Data Chegada na F brica"
    field data-cotacao        as   date format "99/99/9999":U  LABEL "Data Cota‡Æo Nacionaliz"
    field desc-moeda          like moeda.descricao             LABEL "Moeda"
    field mo-taxa             as   decimal format "99999.99999999":U LABEL "Taxa"
    field data-convercao      as   date format "99/99/9999":U        LABEL "Dt ConversÆo"
    FIELD nr-di               LIKE embarque-imp.declaracao-import    LABEL "N£mero DI"
    FIELD dt-di               LIKE embarque-imp.data-di              LABEL "Data DI"
    FIELD sequencia           LIKE item-doc-est.sequencia            LABEL "Sequˆncia"
    field it-codigo           like item.it-codigo                    LABEL "Item"
    field descricao           like item.desc-item
    field quantidade          like item-doc-est.quantidade           LABEL "Quantidade"
    field un                  like item.un                           LABEL "UN".

define temp-table tt-embarque-corpo no-undo
    field embarque                          like embarque-imp.embarque
    field it-codigo                         like item.it-codigo
    field desc-item                         like item.desc-item
    field cod-estabel                       like embarque-imp.cod-estabel
    field desc-estabel                      like estabelec.nome
    field cod-emitente                      like processo-imp.cod-exportador
    field desc-emitente                     like emitente.nome-abrev
    field numero-ordem                      like ordem-compra.numero-ordem
    field nr-fatura                         like invoice-emb-imp.nr-invoice
    field parcela                           like invoice-emb-imp.parcela
    field dt-venc-fat                       like invoice-emb-imp.dt-vencim
    field nr-nota-fis                       like docum-est.nro-docto
    field dt-emissao                        like docum-est.dt-emissao
    field nr-di                             like embarque-imp.declaracao-import
    field dt-di                             like embarque-imp.data-di
    field embarque-rel                      like docum-est.nro-docto
    field nr-nota-rel                       like docum-est.nro-docto
    field dt-emis-rel                       as   date format "99/99/9999":U
    field nr-di-rel                         like embarque-imp.declaracao-import
    field dt-di-rel                         like embarque-imp.data-di
    field vl-ger-mercado-orc                as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ii-orc                     as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ipi-orc                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-icms-orc                   as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-cbs-orc                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ibs-uf-orc                 as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ibs-mun-orc                as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-is-orc                     as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-imp-orc                as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ii2-orc                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-des-orc                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-des-orc                as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-des-orc-aux            as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-imp-des-orc            as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-com-ipi-icms-orc       as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-sem-ipi-icms-orc       as decimal format ">>>,>>>,>>9.99":U
    field per-ger-mercado-orc               as decimal format ">>9.99":U
    field per-ger-ii-orc                    as decimal format ">>9.99":U
    field per-ger-ipi-orc                   as decimal format ">>9.99":U
    field per-ger-icms-orc                  as decimal format ">>9.99":U
    field per-ger-cbs-orc                   as decimal format ">>9.99":U
    field per-ger-ibs-uf-orc                as decimal format ">>9.99":U
    field per-ger-ibs-mun-orc               as decimal format ">>9.99":U
    field per-ger-is-orc                    as decimal format ">>9.99":U
    field per-ger-tot-imp-orc               as decimal format ">>9.99":U
    field per-ger-ii2-orc                   as decimal format ">>9.99":U
    field per-ger-des-orc                   as decimal format ">>9.99":U
    field per-ger-tot-des-orc               as decimal format ">>9.99":U
    field per-ger-tot-imp-des-orc           as decimal format ">>9.99":U
    field per-ger-tot-com-ipi-icms-orc      as decimal format ">>9.99":U
    field per-ger-tot-sem-ipi-icms-orc      as decimal format ">>9.99":U
    field vl-ger-mercado-rea                as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ii-rea                     as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ipi-rea                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-icms-rea                   as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-cbs-rea                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ibs-uf-rea                 as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-ibs-mun-rea                as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-is-rea                     as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-imp-rea                as decimal format ">>>,>>>,>>9.99":U decimals 4
    field vl-ger-ii2-rea                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-des-rea                    as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-des-rea                as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-imp-des-rea            as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-com-ipi-icms-rea       as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-sem-ipi-icms-rea       as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-com-ipi-icms-merc-rea  as decimal format ">>>,>>>,>>9.99":U
    field vl-ger-tot-sem-ipi-icms-merc-rea  as decimal format ">>>,>>>,>>9.99":U
    field per-ger-mercado-rea               as decimal format ">>9.99":U
    field per-ger-ii-rea                    as decimal format ">>9.99":U
    field per-ger-ipi-rea                   as decimal format ">>9.99":U
    field per-ger-icms-rea                  as decimal format ">>9.99":U
    field per-ger-cbs-rea                   as decimal format ">>9.99":U
    field per-ger-ibs-uf-rea                as decimal format ">>9.99":U
    field per-ger-ibs-mun-rea               as decimal format ">>9.99":U
    field per-ger-is-rea                    as decimal format ">>9.99":U
    field per-ger-tot-imp-rea               as decimal format ">>9.99":U
    field per-ger-ii2-rea                   as decimal format ">>9.99":U
    field per-ger-des-rea                   as decimal format ">>9.99":U
    field per-ger-tot-des-rea               as decimal format ">>9.99":U
    field per-ger-tot-imp-des-rea           as decimal format ">>9.99":U
    field per-ger-tot-com-ipi-icms-rea      as decimal format ">>9.99":U
    field per-ger-tot-sem-ipi-icms-rea      as decimal format ">>9.99":U
    field total-vl-frete                    as decimal format ">>>,>>>,>>9.99":U
    field total-vl-embalagem                as decimal format ">>>,>>>,>>9.99":U
    field total-vl-seguro                   as decimal format ">>>,>>>,>>9.99":U
    field total-vl-outras                   as decimal format ">>>,>>>,>>9.99":U
    field per-mercado                       as decimal format ">>9.99":U
    field per-despesa                       as decimal format ">>9.99":U
    field per-imposto                       as decimal format ">>9.99":U
    field per-ii                            as decimal format ">>9.99":U
    FIELD vl-ger-pis-orc                    AS DECIMAL FORMAT ">>>,>>>,>>9.99"
    FIELD vl-ger-cofins-orc                 AS DECIMAL FORMAT ">>>,>>>,>>9.99"
    FIELD vl-ger-pis-rea                    AS DECIMAL FORMAT ">>>,>>>,>>9.99"
    FIELD vl-ger-cofins-rea                 AS DECIMAL FORMAT ">>>,>>>,>>9.99"
    FIELD per-ger-pis-rea                   AS DECIMAL FORMAT ">>9.99"
    FIELD per-ger-cofins-rea                AS DECIMAL FORMAT ">>9.99"
    FIELD per-ger-pis-orc                   AS DECIMAL FORMAT ">>9.99"
    FIELD per-ger-cofins-orc                AS DECIMAL FORMAT ">>9.99"
    FIELD desc-ger-ii2-rea                  LIKE desp-imp.descricao
    FIELD mo-ger-mercado-rea                LIKE docum-est.mo-codigo
    FIELD vl-ger-mercado-rea-mo             as decimal format ">>>,>>>,>>9.99":U
    FIELD mo-ii2-rea                        LIKE docum-est.mo-codigo
    FIELD vl-ger-ii2-rea-mo                 as decimal format ">>>,>>>,>>9.99":U
    index ch-embarque
          embarque
          cod-estabel.

DEFINE TEMP-TABLE tt-embarque-nota-mae NO-UNDO
    field embarque                          like embarque-imp.embarque
    field cod-estabel                       like embarque-imp.cod-estabel
    field nr-nota-fis                       like docum-est.nro-docto
    field dt-emissao                        like docum-est.dt-emissao
    field nr-di                             like embarque-imp.declaracao-import
    field dt-di                             like embarque-imp.data-di.

DEFINE TEMP-TABLE tt-embarque-nf NO-UNDO
    field embarque                          like embarque-imp.embarque
    field cod-estabel                       like embarque-imp.cod-estabel
    field nr-nota-fis                       like docum-est.nro-docto
    field dt-emissao                        like docum-est.dt-emissao
    field nr-di                             like embarque-imp.declaracao-import
    field dt-di                             like embarque-imp.data-di.

define temp-table tt-embarque-fatura no-undo
    field embarque                     like embarque-imp.embarque
    field cod-estabel                  like embarque-imp.cod-estabel
    field nr-fatura                    like invoice-emb-imp.nr-invoice
    field parcela                      like invoice-emb-imp.parcela
    field dt-venc-fat                  like invoice-emb-imp.dt-vencim.

define temp-table tt-detalha-despesa no-undo
    field embarque      like embarque-imp.embarque
    field cod-estabel   like embarque-imp.cod-estabel
    field nro-docto     like item-doc-est.nro-docto
    field numero-ordem  like cotacao-item.numero-ordem
    field sequencia     like item-doc-est.sequencia
    field it-codigo     like item-doc-est.it-codigo
    field cod-despesa   like desp-imp.cod-desp
    field desc-despesa  like desp-imp.descricao
    field situacao      as   int
    field vl-des-orc    as   decimal format ">>>,>>>,>>9.99999":U
    field vl-des-rea    as   decimal format ">>>,>>>,>>9.99999":U
    field per-des-orc   as   decimal format ">>9.99":U
    field per-des-rea   as   decimal format ">>9.99":U.

DEFINE TEMP-TABLE tt-detalha-despesa-aux NO-UNDO
    FIELD embarque        LIKE embarque-imp.embarque
    FIELD cod-estabel     LIKE embarque-imp.cod-estabel
    FIELD cod-despesa     LIKE desp-imp.cod-desp
    FIELD desc-despesa    LIKE desp-imp.descricao
    FIELD vl-des-orc      AS   DECIMAL FORMAT ">>>,>>>,>>9.99":U
    FIELD vl-des-rea      AS   DECIMAL FORMAT ">>>,>>>,>>9.99":U
    FIELD per-des-orc     AS   DECIMAL FORMAT ">>9.99":U
    FIELD per-des-rea     AS   DECIMAL FORMAT ">>9.99":U
    FIELD sequencia       LIKE item-doc-est.sequencia
    field situacao        as   int
    FIELD vl-des-rea-mo   AS   DECIMAL FORMAT ">>>,>>>,>>9.99":U
    FIELD moeda-mo        LIKE docum-est.mo-codigo
    index ch-codigo is unique primary
          embarque
          cod-estabel
          cod-despesa
          sequencia.

define temp-table tt-embarque-rel no-undo
    field embarque      like embarque-imp.embarque
    field cod-estabel   like embarque-imp.cod-estabel
    field embarque-rel  like docum-est.nro-docto
    field nr-nota-rel   like docum-est.nro-docto
    field dt-emis-rel   as   date format "99/99/9999":U
    field nr-di-rel     like embarque-imp.declaracao-import
    field dt-di-rel     like embarque-imp.data-di.

define temp-table tt-nf-comp no-undo
    field embarque       like embarque-imp.embarque
    field cod-estabel    like embarque-imp.cod-estabel
    field nr-nf-comp     like docum-est.nro-docto
    field dt-emis-comp   like docum-est.dt-emissao
    FIELD tot-valor      LIKE docum-est.tot-valor
    FIELD tot-imposto    LIKE docum-est.tot-valor format ">>,>>>,>>>,>>9.9999"  decimals 4
    FIELD moeda-mo       LIKE docum-est.mo-codigo
    FIELD tot-valor-mo   LIKE docum-est.tot-valor
    FIELD tot-imposto-mo LIKE docum-est.tot-valor format ">>,>>>,>>>,>>9.9999"  decimals 4.

def temp-table tt-embarque-corpo-agr like tt-embarque-corpo
    index ch-emitente
          cod-estabel
          cod-emitente
          embarque.

{inbo/boin759.i tt-impto-item-docto}

DEFINE TEMP-TABLE tt-detalha-despesas-comp-equador NO-UNDO LIKE tt-detalha-despesa-aux .

DEF TEMP-TABLE tt-impto-internac NO-UNDO
    FIELD embarque                 LIKE embarque-imp.embarque
    FIELD cod-estabel              LIKE embarque-imp.cod-estabel
    FIELD cdn-imposto              LIKE impto-item-docto.cdn-imposto
    FIELD num-seq                  LIKE impto-item-docto.num-seq
    FIELD descricao                LIKE tipo-tax.descricao
    FIELD val-impto-moeda-relat    LIKE tt-impto-item-docto.val-impto
    FIELD perc-impto               AS DECIMAL FORMAT ">>9.99":U
    FIELD val-impto-moeda-relat-mo LIKE tt-impto-item-docto.val-impto
    FIELD mo-impto-moeda-relat     LIKE docum-est.mo-codigo
    INDEX id IS PRIMARY embarque cod-estabel cdn-imposto.


DEFINE VARIABLE l-nt2024002 AS LOGICAL     NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).
/* Fim da include */

