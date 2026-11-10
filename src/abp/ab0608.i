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
     field periodo-ini        like mab-abastec-lubrific.dat-movto
     field periodo-fim        like mab-abastec-lubrific.dat-movto
     field empresa-ini        like mab-abastec-lubrific.ep-codigo
     field empresa-fim        like mab-abastec-lubrific.ep-codigo
     field estabeqpto-ini     like mab-eqpto.cod-estabel
     field estabeqpto-fim     like mab-eqpto.cod-estabel
     field equipto-ini        like mab-abastec-lubrific.cod-eqpto
     field equipto-fim        like mab-abastec-lubrific.cod-eqpto
     field grupo-ini          like mab-eqpto.cod-grp-eqpto
     field grupo-fim          like mab-eqpto.cod-grp-eqpto
     field modelo-ini         like mab-eqpto.cod-model
     field modelo-fim         like mab-eqpto.cod-model
     field docto-ini          like mab-abastec-lubrific.num-docto
     field docto-fim          like mab-abastec-lubrific.num-docto
     field estab-ini          like mab-eqpto.cod-estabel
     field estab-fim          like mab-eqpto.cod-estabel
     field hora-ini           like mab-abastec-lubrific.hra-inicial
     field hora-fim           like mab-abastec-lubrific.hra-inicial
     field posto-ini          like mab-abastec-lubrific.cod-posto
     field posto-fim          like mab-abastec-lubrific.cod-posto
     field bomba-ini          like mab-item-abastec.cod-bomba
     field bomba-fim          like mab-item-abastec.cod-bomba
     field matrl-ini          as char format "x(08)" 
     field matrl-fim          as char format "x(08)"
     field item-ini           as char format "x(16)"
     field item-fim           as char format "x(16)"
     FIELD cod-motorista-ini  LIKE mab-abastec-lubrific.cod-matr
     FIELD cod-motorista-fim  LIKE mab-abastec-lubrific.cod-matr
     field emitente-ini       like mab-posto.cod-emitente
     field emitente-fim       like mab-posto.cod-emitente
     field nota-ini           like mab-abastec-lubrific.nr-nota-fis
     field nota-fim           like mab-abastec-lubrific.nr-nota-fis
     field evento-ini         like mab-item-lubrific.cod-evento
     field evento-fim         like mab-item-lubrific.cod-evento
     field ccusto-ini-item    like mab-abastec-lubrific.cc-codigo
     field ccusto-fim-item    like mab-abastec-lubrific.cc-codigo
     field comptmento-ini     like mab-item-lubrific.cod-comptmento
     field comptmento-fim     like mab-item-lubrific.cod-comptmento
     field cod-ativid-ini     like mab-ativid.cod-ativid
     field cod-ativid-fim     like mab-ativid.cod-ativid
     field cod-tag-ini        like tag.cd-tag
     field cod-tag-fim        like tag.cd-tag
     field lCombutivel        as logical     
     field lLubrific          as logical
     field lProprios          as logical
     field lTerceiros         as logical
     field lHabilita          as logical
     field lAtualiza          as logical
     field cb-moeda           as char
     field classifica         as integer format "9"
     FIELD lAtivos            as logical
     FIELD lInativos          as logical
     FIELD lMotorizados       as logical
     FIELD lNmotorizados      as logical
     FIELD lTerc              as logical
     FIELD lProprio           as logical
     field lIntegrados        as logical
     field lNaoIntegrados     as LOGICAL
     field cod-emitente-ini   like mab-eqpto.cod-emitente
     field cod-emitente-fim   like mab-eqpto.cod-emitente
    &IF DEFINED(bf_mnt_ems206b) &THEN
     FIELD cod-unid-negoc-eqpto-ini AS CHARACTER FORMAT "x(3)"
     FIELD cod-unid-negoc-eqpto-fim AS CHARACTER FORMAT "x(3)"
     FIELD cod-unid-negoc-ficha-ini AS CHARACTER FORMAT "x(3)"
     FIELD cod-unid-negoc-ficha-fim AS CHARACTER FORMAT "x(3)"
    &ENDIF
     FIELD trajeto-ini LIKE mab-abastec-lubrific.cod-rota
     FIELD trajeto-fim LIKE mab-abastec-lubrific.cod-rota
     FIELD lBuscaMovtoEstoque AS LOGICAL.

define temp-table ttSelecao2 no-undo
     field empresa-ini      like mab-eqpto.ep-codigo
     field empresa-fim      like mab-eqpto.ep-codigo
     field equipto-ini      like mab-eqpto.cod-eqpto
     field equipto-fim      like mab-eqpto.cod-eqpto
     field grupo-ini        like mab-eqpto.cod-grp-eqpto
     field grupo-fim        like mab-eqpto.cod-grp-eqpto
     field modelo-ini       like mab-eqpto.cod-model
     field modelo-fim       like mab-eqpto.cod-model
     field estab-ini        like mab-eqpto.cod-estabel
     field estab-fim        like mab-eqpto.cod-estabel
     field tag-ini          like mab-eqpto.cd-tag
     field tag-fim          like mab-eqpto.cd-tag
     field estrut-ini       like mab-eqpto.cod-estrut-mec
     field estrut-fim       like mab-eqpto.cod-estrut-mec
     field cc-cod-eqpto-ini like mab-eqpto.cc-codigo
     field cc-cod-eqpto-fim like mab-eqpto.cc-codigo
     field sit-ini          like mab-eqpto.cod-sit-eqpto
     field sit-fim          like mab-eqpto.cod-sit-eqpto
     field atividade-ini    like mab-histor-ativid.cod-ativid  
     field atividade-fim    like mab-histor-ativid.cod-ativid
     field periodo-ini      as date format "99/99/9999"
     field periodo-fim      as date format "99/99/9999"
     field trajeto-ini      like mab-abastec-lubrific.cod-rota
     field trajeto-fim      like mab-abastec-lubrific.cod-rota
     FIELD cc-cod-docto-ini like mab-eqpto.cc-codigo
     FIELD cc-cod-docto-fim like mab-eqpto.cc-codigo
     field lAtivos          as logical     
     field lProprios        as logical
     field lInativos        as logical
     field lTerceiros       as logical
     field lOK              as logical
     field lIrregular       as logical
     field lLogContSec      as logical
     field lDesperdicio     as logical
     field classificacao    as integer format "9"
     field cod-emitente-ini like mab-eqpto.cod-emitente
     field cod-emitente-fim like mab-eqpto.cod-emitente
    &IF DEFINED(bf_mnt_ems206b) &THEN
     FIELD cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
     FIELD cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)"
    &ENDIF
     .       


/**Temp-table para dados do Excell**/
define temp-table tt-dados-ex no-undo
    field arquivo-num                   as integer format ">9"     initial 1
    field planilha-num                  as integer format ">9"
    field celula-coluna                 as integer format ">>>>9"
    field celula-linha                  as integer format ">>>>9"
    field celula-cor-interior           as integer format ">9"     initial 58 /* None */
    field celula-formato                as char    format "x(255)"
    field celula-formula                as char    format "x(255)"
    field celula-alinhamento-horizontal as integer format "9"      initial 4 /* Left */
    field celula-alinhamento-vertical   as integer format "9"      initial 1 /* Bottom */
    field celula-valor                  as char    format "x(255)"
    field celula-fonte-nome             as char    format "x(255)" initial "Times New Roman"
    field celula-fonte-tamanho          as integer format ">9"     initial 10
    field celula-fonte-negrito          as logical                 initial no
    field celula-fonte-italico          as logical                 initial no
    field celula-fonte-sublinhado       as integer format "9"      initial 3 /* None */
    field celula-fonte-cor              as integer format ">9"     initial 57 /* Automatic */
    field celula-tipo-borda-sup         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-inf         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-esq         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-dir         as integer format "9"      initial 7 /* None */
    index tt-dados-pri is unique primary
        arquivo-num
        planilha-num
        celula-coluna
        celula-linha.







