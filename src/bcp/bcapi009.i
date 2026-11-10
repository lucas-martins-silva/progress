/**************************************************************************
**
**   Include: BCAPI009.I - Definicao da temp-table tt-param-bc
**
***************************************************************************/

def temp-table tt-param-bc NO-UNDO
    field cod-versao-integracao     as integer
    field i-sequen                  as integer 
    field cod_servid_exec_atualiz   as char format "x(008)"
    field cod_servid_exec_import    as char format "x(008)"
    field nome-dir-etiq             as char format "x(256)"
    field pto-decimal               as logical
    field tp-etiq-padrao            as inte format "9999"
    field conta-entrada             as char format "x(017)"
    field conta-saida               as char format "x(017)"
    field dt-transf                 as date
    field nr-contagem               as integer
    index ch-seq is unique primary i-sequen.
