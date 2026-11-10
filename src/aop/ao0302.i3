/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*******************************************
** {1} = Nome da temp-table
** {2} = Define o tipo de temp-table (ex: shared)
*******************************************/

/** Dados **/
def {2} temp-table {1} no-undo    
    field sequencia               as   integer
    field cod-dimensao            as   character format "x(300)"
    field cod-oficial             as   character format "X(20)"
    field desc-dimensao           as   character format "x(100)"
    field cod-dimens-pai          as   character format "x(300)"
    field ep-codigo               like mao-amostra-oleo.ep-codigo
    field cod-eqpto               like mao-amostra-oleo.cod-eqpto
    field desc-eqpto              like mab-model.des-model
    field cod-ensaio              like mao-restdo-ensaio.cod-ensaio
    field data                    like mao-amostra-oleo.dat-amostra
    field hora                    like mao-amostra-oleo.hra-amostra
    field cod-comptmento          like mao-amostra-oleo.cod-comptmento
    field desc-comptmento         like mab-comptmento.des-comptmento
    field cod-tip-mater           like mao-amostra-oleo.cod-tip-mater
    field desc-mater              like mab-tip-mater.des-tip-mater
    field dUltTroca               as   date
    field num-amostra-oleo        like mao-amostra-oleo.num-amostra-oleo
    field cod-amostra-fisic       like mao-amostra-oleo.cod-amostra-fisic
    field dat-restdo-ensaio       like mao-restdo-ensaio.dat-restdo-ensaio
    field hra-restdo-ensaio       like mao-restdo-ensaio.hra-restdo-ensaio
    field val-quant               like mao-amostra-oleo.val-quant
    field num-docto               like mao-amostra-oleo.num-docto
    field idi-consist             like mab-abastec-lubrific.idi-consist
    field idi-estado-amostra      like mao-amostra-oleo.idi-estado-amostra
    field idi-estado-ensaio       like mao-restdo-ensaio.idi-estado-ensaio
    field log-padrao              like mao-restdo-ensaio.log-padrao
    field des-val-restdo          like mao-restdo-ensaio.des-val-restdo
    field des-val-max             like  mao-restdo-ensaio.des-val-max 
    field des-val-min             like  mao-restdo-ensaio.des-val-min
    field num-tabela              like  mao-restdo-ensaio.num-tabela
    field dat-result              like mao-restdo-ensaio.des-val-restdo
    field dat-result-ant          like mao-restdo-ensaio.des-val-restdo 
    field idi-tip-restdo          like  mao-ensaio.idi-tip-restdo
    field des-formato             like mao-restdo-ensaio.des-formato
    field dsl-obs                 like  mao-restdo-ensaio.dsl-obs
    field d-data-ult-amostra      as   date
    field num-ult-amostra-oleo    like mao-amostra-oleo.num-amostra-oleo
    field d-data-penult-amostra   as   date    
    field num-penult-amostra-oleo like mao-amostra-oleo.num-amostra-oleo
    field r-rowid                 as   rowid
    field p-image                 as   integer
    field seq-tree                as   integer
    field i-cont                  as   integer
    index id is primary unique sequencia ascending
                               cod-dimensao ascending
                               cod-ensaio   ascending
    index docto cod-amostra-fisic ascending
                cod-oficial       ascending
                cod-ensaio        ascending.

                               
 
