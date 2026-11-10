/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/** Sele‡Æo **/
/*Quando alterar esta defini‡Æo ser  necess rio sincronizar com a include gfp/gf0602.i */
define temp-table ttSelecao no-undo
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
