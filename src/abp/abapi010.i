/********************************************************************************
** Copyright DATASUL S.A. (2005)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: abapi010.i
**
**       DATA....: Maio / 2005
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: chamada pela abapi010.p - definição de temp-tables
**
*****************************************************************************/

/*--- Temporary Table Definitions ---*/

def temp-table tt_trans_bem no-undo        
    field ttv_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field ttv_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem Pat"
    field ttv_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequencia Bem" column-label "Sequencia"
    field ttv_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_ccusto                   as Character format "x(20)" label "Centro Custo" column-label "Centro Custo"
    FIELD tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_dat_trans                    as date format "99/99/9999" initial ?
    field ttv_hra_trans                    as Character format "99:99:99"
    index tt_indice_trans_bem              is primary unique
          ttv_cod_empresa                  ascending
          ttv_cod_cta_pat                  ascending
          ttv_num_bem_pat                  ascending
          ttv_num_seq_bem_pat              ascending
    .

def temp-table tt_row_errors no-undo        
    field ttv_num_seq_erro                 as integer format ">>>>,>>9"
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistencia" column-label "Inconsistencia"
    field ttv_des_param                    as character format "x(50)" label "Param" column-label "Param"
    field ttv_des_type                     as character format "x(10)"
    field ttv_des_help                     as character format "x(40)" label "Ajuda" column-label "Ajuda"
    field ttv_des_sub_type                 as character format "x(40)"
    index tt_indice_errors                
          ttv_num_seq_erro                 ascending
    .

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.
