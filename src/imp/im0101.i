/****************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/** Definicao temp-table para programa Geracao Despesas Nota Complementar (im0101) **/
def temp-table {1} no-undo
    field embarque              like embarque-imp.embarque
    field cod-estabel           like estabelec.cod-estabel
    field cod-emitente-desp     like emitente.cod-emitente
    FIELD num-di-ems            LIKE decla-import.num-di-ems
    field estado-emite          like emitente.estado
    field da-transacao          as   date
    field da-emissao            as   date
    field da-venc-ipi           as   date
    field da-venc-icms          as   date
    field nro-docto             like docum-est.nro-docto
    field serie                 like docum-est.serie-docto
    field nat-operacao          like docum-est.nat-operacao
    field estab-fisc            like estabelec.cod-estabel
    field ct-transit            like ct-transit-import
	field sc-transit	        like sc-transit-import
    field da-cotacao            as   date
    field observacao            as   char format "x(2000)"
    field usuario               like param-re.usuario
    field i-pais-impto-usuario  as integer
    field aliquota-ipi          as   decimal format ">>9.99"
    field aliquota-icms         as   decimal format ">>9.99"
    field aliquota-pis          as   decimal format ">>9.9999"
    field aliquota-cofins       as   decimal format ">>9.9999"
    field i-tributacao-ipi      as   integer
    field i-tributacao-icms     as   integer
    field i-tributacao-pis      as   integer
    field i-tributacao-cofins   as   integer
    field cod-observacao        as   integer
    field l-acomp               as   logical
    field l-agrupar-unico-forn  as   logical
    FIELD chave-nfe             AS   CHARACTER FORMAT "x(60)"
    field declaracao-import     like embarque-imp.declaracao-import
    field da-di                 as   date
    FIELD cod-item-serv         AS   CHARACTER FORMAT "x(16)"
    FIELD cod-ibge-orig         AS   CHARACTER FORMAT "X(7)"
    FIELD cod-ibge-dest         AS   CHARACTER FORMAT "X(7)"
    FIELD aliquota-ibsuf        AS   DECIMAL FORMAT ">>9.99"
    FIELD aliquota-ibsmun       AS   DECIMAL FORMAT ">>9.99"
    FIELD aliquota-cbs          AS   DECIMAL FORMAT ">>9.99"
    FIELD perc-red-ibsuf        AS   DECIMAL FORMAT ">>9.99"
    FIELD perc-red-ibsmun       AS   DECIMAL FORMAT ">>9.99"
    FIELD perc-red-cbs          AS   DECIMAL FORMAT ">>9.99"
    FIELD aliquota-is           AS   DECIMAL FORMAT ">>9.99"
    index codigo is unique primary
        cod-estabel
        embarque.
        
def temp-table {1}-aux no-undo
    field cod-estabel       like estabelec.cod-estabel
    field embarque          like embarque-imp.embarque
    FIELD num-di-ems        LIKE decla-import.num-di-ems
    field mo-codigo         like moeda.mo-codigo
    field cod-cond-pag      like cond-pagto.cod-cond-pag
    field da-partida        as   date format "99/99/9999"
    field tp-despesa        as   integer
    field cotacao-dia       like cotacao.cotacao extent 0
    field valor-mercad      like docum-est.valor-mercad extent 0
    field valor-duplic      like docum-est.valor-mercad extent 0 
    field valor-mercad-me   like docum-est.valor-mercad extent 0
    field valor-duplic-me   like docum-est.valor-mercad extent 0
    field nome-abrev        like emitente.nome-abrev
    field portador          like emitente.portador
    field modalidade        like emitente.modalidade
    field natureza          like emitente.natureza    
    field consum-final      like natur-oper.consum-final
    field cod-mensagem      like natur-oper.cod-mensagem
    field estado-estab      like estabelec.estado
    field cidade            like estabelec.cidade
    field pais              like estabelec.pais
    field esp-tit-rec       like param-imp.esp-tit-rec
    field seq-item-um       like param-re.seq-item-um
    field inc-seq           like param-re.inc-seq
    field natur-oper-char-2 like natur-oper.char-2
    field imp-nota          like natur-oper.imp-nota
    field cd-trib-iss       like natur-oper.cd-trib-iss
    field emite-duplic      as   logical
    field declaracao-import like embarque-imp.declaracao-import
    field da-di             as   date
    FIELD cod-ibge-orig     AS   CHARACTER FORMAT "X(7)"
    FIELD cod-ibge-dest     AS   CHARACTER FORMAT "X(7)"
    index codigo is unique primary
        cod-estabel
        embarque.
        
/* IM0101.I */
        
