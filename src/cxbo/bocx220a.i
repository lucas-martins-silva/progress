/*
**
** BOCX220A.I - Include Parƒmetros Valida‡Æo Desembarque/Gera‡Æo Documentos Entrada (im0100)
**
*/

def temp-table tt-parametros no-undo
    field cod-estabel           like estabelec.cod-estabel
    field embarque              like embarque-imp.embarque
    field cod-emitente          like emitente.cod-emitente
    field da-transacao          as   date
    field da-emissao            as   date
    field da-venc-ipi           as   date
    field da-venc-icms          as   date
    field nro-docto             like docum-est.nro-docto
    field serie                 like docum-est.serie
    field nat-operacao          like docum-est.nat-operacao
    field estab-fisc            like processo-imp.estab-fisc
    field ct-transit         like param-imp.ct-transit-import
	field sc-transit		like param-imp.sc-transit-import
    field declaracao-import     like embarque-imp.declaracao-import
    field da-di                 as   date
    field de-tot-desconto       like docum-est.tot-valor
    field da-cotacao            as   date
    field observacao            as   char format "x(2000)"
    field usuario               like param-re.usuario
    field i-pais-impto-usuario  as   integer
    field l-chama-carregado     as   logical
    field l-icms-diferido       as   logical
    &if defined(bf_mat_nf_simp_remes_desp_imp) &then
    field l-nf-simples-remessa  as   logical
    field idi-nf-simples-remes  as   integer /* like docum-est.idi-nf-simples-remes */
   /* field conta-contabil        AS   CHAR FORMAT "x(20)":U*/
	field ct-codigo as char format "x(20)"
	field sc-codigo as char format "x(20)"
    &endif
    index codigo is unique primary
        cod-estabel
        embarque.

define temp-table tt-itens-aux-serie no-undo
    field numero-ordem      like ordens-embarque.numero-ordem
    field parcela           like ordens-embarque.parcela
    field preco-unit        like item-doc-est.preco-unit  extent 0
    field preco-unit-acum   like item-doc-est.preco-unit  extent 0
    field preco-total-acum  like item-doc-est.preco-unit  extent 0
    field peso-liquido      like item-doc-est.peso-liquido
    field peso-liquido-acum like item-doc-est.peso-liquido
    field peso-bruto        like item-doc-est.peso-liquido
    field peso-bruto-acum   like item-doc-est.peso-liquido
    index id
          numero-ordem
          parcela.

/* BOCX220A.I */

