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
     field empresa-ini    like mab-eqpto.ep-codigo
     field empresa-fim    like mab-eqpto.ep-codigo
     field equipto-ini    like mab-eqpto.cod-eqpto
     field equipto-fim    like mab-eqpto.cod-eqpto
     field grupo-ini      like mab-eqpto.cod-grp-eqpto
     field grupo-fim      like mab-eqpto.cod-grp-eqpto
     field modelo-ini     like mab-eqpto.cod-model
     field modelo-fim     like mab-eqpto.cod-model
     field estab-ini      like mab-eqpto.cod-estabel
     field estab-fim      like mab-eqpto.cod-estabel
     field tag-ini        like mab-eqpto.cd-tag
     field tag-fim        like mab-eqpto.cd-tag
     field cc-ini         like mab-histor-ativid.cc-codigo
     field cc-fim         like mab-histor-ativid.cc-codigo
     field estrut-ini     like mab-eqpto.cod-estrut-mec
     field estrut-fim     like mab-eqpto.cod-estrut-mec
     field gr-ev-ini      like mab-grp-event.cod-grp-event
     field gr-ev-fim      like mab-grp-event.cod-grp-event
     field evento-ini     like mab-event.cod-evento
     field evento-fim     like mab-event.cod-evento
     field comp-ini       like mab-comptmento.cod-comptmento  
     field comp-fim       like mab-comptmento.cod-comptmento
     field lAtivos        as logical
     field lInativos      as logical
     field lProprios      as logical
     field lTerceiros     as logical
     field lMotor         as logical
     field lNMotor        as logical
     field lVencido       as logical
     field lAVencer       as logical
     field lOutros        as logical
     field lServico       as logical
     field iPlano         as integer
    &IF DEFINED(bf_mnt_ems206b) &THEN
     FIELD unid-negoc-ini AS CHARACTER FORMAT "x(3)"
     FIELD unid-negoc-fim AS CHARACTER FORMAT "x(3)"
    &ENDIF
     .
