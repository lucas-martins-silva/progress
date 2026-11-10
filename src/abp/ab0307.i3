/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/** Dados **/
def temp-table ttDados no-undo like mab-abastec-lubrific
    field cod-estabel-eqpto    like mab-eqpto.cod-estabel
    field cd-tag-eqpto         like mab-eqpto.cd-tag
    field cc-codigo-eqpto      like mab-eqpto.cc-codigo
    field mes-ano               as   character format "x(07)"
    field cod-estabel-posto    like mab-posto.cod-estabel
    field cod-depos-posto      like mab-posto.cod-depos
    field cod-model-eqpto      like mab-eqpto.cod-model
    field cod-bomba            like mab-bomba.cod-bomba
    field i-filho               as   integer   format "9"
    field r-rowid               as   rowid
    field seq-1                 as   integer
    field cod-dimensao          as   character format "x(300)"
    field cod-oficial           as   character format "X(20)"
    field desc-dimensao         as   character format "x(100)"
    field cod-dimens-pai        as   character format "x(300)"
    field p-image               as   integer
    field seq-tree              as   integer
    field i-cont                as   integer
    index id is primary unique sequencia     ascending
                               num-docto     ascending
    index data                 dat-movto     ascending
                               sequencia     ascending 
                               num-docto     ascending
    index dime                 cod-dimensao  ascending
                               desc-dimensao ascending.
                               
def temp-table ttQuantidades no-undo
    field it-codigo            like mab-item-abastec.it-codigo
    field qtd                  like mab-item-abastec.val-quant
    field estab-posto          like mab-posto.cod-estabel
    field dep-posto            like mab-posto.cod-depos
    field log-abastec-prim     like mab-item-abastec.log-abastec-prim
    field cod-tip-mater        like mab-item-abastec.cod-tip-mater
    field r-rowid              as rowid.
