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
     /** Faixas **/
     field empresa-ini    like mab-eqpto.ep-codigo
     field empresa-fim    like mab-eqpto.ep-codigo
     field equipto-ini    like mab-eqpto.cod-eqpto
     field equipto-fim    like mab-eqpto.cod-eqpto
     field docto-ini      like mao-amostra-oleo.num-amostra-oleo
     field docto-fim      like mao-amostra-oleo.num-amostra-oleo
     field modelo-ini     like mab-eqpto.cod-model
     field modelo-fim     like mab-eqpto.cod-model
     field amostra-ini    like mao-amostra-oleo.cod-amostra-fisic 
     field amostra-fim    like mao-amostra-oleo.cod-amostra-fisic 
     field data-ini       like mao-amostra-oleo.dat-amostra
     field data-fim       like mao-amostra-oleo.dat-amostra
     field compto-ini     like mao-amostra-oleo.cod-comptmento
     field compto-fim     like mao-amostra-oleo.cod-comptmento
     field tp-mater-ini   like mao-amostra-oleo.cod-tip-mater
     field tp-mater-fim   like mao-amostra-oleo.cod-tip-mater
     field lubrific-ini   like mao-amostra-oleo.num-docto
     field lubrific-fim   like mao-amostra-oleo.num-docto
     field tag-ini        like mab-eqpto.cd-tag
     field tag-fim        like mab-eqpto.cd-tag
     field cc-ini         like mab-histor-ativid.cc-codigo
     field cc-fim         like mab-histor-ativid.cc-codigo
     /** Parƒmetros **/
     field lPadrao          as logical
     field lNPadrao         as logical
     field lData            as logical
     field lTexto           as logical
     field lNumerico        as logical
     field lTabela          as logical
     field lAprovado        as logical
     field lReprovado       as logical
     field lPendente        as logical
     field lAprovUsuar      as logical
     field lAmostAprovado   as logical
     field lAmostReprovado  as logical
     field lAmostPendente   as logical
     field lAmostAprovUsuar as LOGICAL
    &IF DEFINED(bf_mnt_ems206b) &THEN
     FIELD unid-negoc-ini   AS CHARACTER FORMAT "x(3)"
     FIELD unid-negoc-fim   AS CHARACTER FORMAT "x(3)"
    &ENDIF
     .
   
