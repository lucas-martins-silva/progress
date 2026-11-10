/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/** Sele‡Æo **/
define temp-table ttSelecao no-undo
    FIELD dat-ini         LIKE mab-abastec-lubrific.dat-movto
    FIELD dat-fim         LIKE mab-abastec-lubrific.dat-movto
    FIELD ep-codigo-ini   LIKE mab-eqpto.ep-codigo
    FIELD ep-codigo-fim   LIKE mab-eqpto.ep-codigo
    FIELD estab-eqpto-ini LIKE mab-eqpto.cod-estabel
    FIELD estab-eqpto-fim LIKE mab-eqpto.cod-estabel
    FIELD tag-ini         LIKE mab-eqpto.cd-tag
    FIELD tag-fim         LIKE mab-eqpto.cd-tag
    FIELD cc-codigo-ini   LIKE mab-eqpto.cc-codigo
    FIELD cc-codigo-fim   LIKE mab-eqpto.cc-codigo
    FIELD cod-eqpto-ini   LIKE mab-eqpto.cod-eqpto
    FIELD cod-eqpto-fim   LIKE mab-eqpto.cod-eqpto
    FIELD estab-posto-ini LIKE mab-posto.cod-estabel
    FIELD estab-posto-fim LIKE mab-posto.cod-estabel
    FIELD posto-ini       LIKE mab-posto.cod-posto
    FIELD posto-fim       LIKE mab-posto.cod-posto
    FIELD bomba-ini       LIKE mab-bomba.cod-bomba
    FIELD bomba-fim       LIKE mab-bomba.cod-bomba
    FIELD deposito-ini    LIKE mab-posto.cod-depos
    FIELD deposito-fim    LIKE mab-posto.cod-depos
    FIELD cod-model-ini   LIKE mab-eqpto.cod-model
    FIELD cod-model-fim   LIKE mab-eqpto.cod-model
    FIELD iVisualiza      AS INTEGER FORMAT "9"
    FIELD lAtivos         AS LOGICAL
    FIELD lInativos       AS LOGICAL
    FIELD lProprios       AS LOGICAL
    FIELD lTerceiros      AS LOGICAL
    FIELD lMotorizados    AS LOGICAL
    FIELD lNMotorizados   AS LOGICAL
    FIELD iAtualiza       AS INTEGER FORMAT "99"
&IF DEFINED(bf_mnt_ems206b) &THEN
    FIELD cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
    FIELD cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)"
&ENDIF
    .
