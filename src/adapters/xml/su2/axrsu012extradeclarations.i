
{cdp/cdapi366b.i} /* Definiá∆o das temp-tables evolu°das integraá∆o via ems2 */

DEF TEMP-TABLE tt-integra-fornecedor NO-UNDO
    FIELD cgc            AS CHAR /* Identificaá∆o Federal ( campo = mgadm.emitente.cgc ou emsuni.cliente.cod_id_feder ou emsuni.fornecedor.cod_id_feder) */
    FIELD nome-emit      AS CHAR /* Raz∆o Social ( campo = mgadm.emitente.nome-emit ou emsuni.pessoa_jurid.nom_pessoa) */
    FIELD ins-estadual   AS CHAR /* ID Estadual ( campo = mgadm.emitente.ins-estadual ou emsuni.pessoa_jurid.cod_id_estad_jurid ou emsuni.pessoa_fisic.id_estadual_fisic) */
    FIELD ins-municipal  AS CHAR /* ID Municipal ( campo = mgadm.emitente.ins-municipal ou emsuni.pessoa_jurid.cod_id_munic_jurid) */
    FIELD endereco       AS CHAR /* Endereco por extenso (Uso interno: Campo = mgadm.emitente.endereco) */
    FIELD bairro         AS CHAR /* Bairro para a entrega do pedido. (Uso interno: Campo = mgadm.emitente.bairro) */
    FIELD cidade         AS CHAR /* Cidade para a entrega do pedido. (Uso interno: Campo = mgadm.emitente.cidade) */
    FIELD estado         AS CHAR /* Unidade de Federaá∆o. (Uso interno: Campo = mgadm.emitente.estado) */
    FIELD pais           AS CHAR /* Pais para a entrega do pedido. (Uso interno: Campo = mgadm.emitente.pais) */
    FIELD cep            AS CHAR /* CEP para a entrega do pedido. (Uso interno: Campo = mgadm.emitente.cep) */
    FIELD telefone       AS CHAR /* Telefone 1 ( campo = mgadm.emitente.telefone[1] ou emsuni.pessoa_jurid.cod_telefone ou emsuni.pessoa_fisic.cod_telefone) */
    FIELD email          AS CHAR /* E-mail ( campo = mgadm.emitente.e-mail ou emsuni.pessoa_jurid.cod_e_mail ou emsuni.pessoa_fisic.cod_e_mail) */
    FIELD homepage       AS CHAR /* Home Page ( campo = mgadm.emitente.home-page ou emsuni.pessoa_jurid.nom_home_page ou emsuni.pessoa_fisic.nom_home_page) */
    FIELD natureza-EMS2  AS INT
    FIELD cod-emitente   AS INT
    FIELD nome-abrev     AS CHAR
    FIELD nome-matriz    AS CHAR
    FIELD cod-portador   AS CHAR
    FIELD modalidade     AS CHAR
    FIELD cod-gr-forn    AS CHAR
    FIELD tp-desp-padrao as char
    FIELD ep-codigo-prin as char
    FIELD ep-codigo      as char
    .

DEF VAR l-existe-fornecedor AS LOG    NO-UNDO.
DEF VAR i-emitente          AS INT    NO-UNDO.
DEF VAR c-cod-arquivo-log   AS CHAR   NO-UNDO.
DEF VAR c-identifiq         AS CHAR   NO-UNDO.
DEF VAR c-auxliter          AS CHAR   NO-UNDO.
DEF VAR c-cod-fornecedor    AS INT    NO-UNDO.
DEF VAR h_axsfi001          AS HANDLE NO-UNDO.
DEF VAR h-cdapi366b         AS HANDLE NO-UNDO.
DEF VAR v-cod-empres-usuar  AS CHAR   NO-UNDO.
DEF VAR l-log-error         AS LOG    NO-UNDO.
