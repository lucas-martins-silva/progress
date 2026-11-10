/********************************************************************************
** Copyright DATASUL S.A. (2005)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: abapi011.i
**
**       DATA....: Agosto / 2005
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: chamada pela abapi011.p - defini‡Æo de temp-tables
**
*****************************************************************************/

/*--- Temporary Table Definitions ---*/

DEF TEMP-TABLE tt_trans_bem
  &IF "{&mguni_version}" >= "2.071" &THEN
    FIELD ttv_num_empresa     LIKE empresa.ep-codigo FORMAT "x(03)" LABEL "Empresa"             COLUMN-LABEL "Empresa"
  &ELSE
    FIELD ttv_num_empresa     AS INTEGER   FORMAT "999"   LABEL "Empresa"                       COLUMN-LABEL "Empresa"
  &ENDIF
    FIELD ttv_cod_cta_pat     AS CHARACTER FORMAT "x(18)" LABEL "Conta Patrimonial"             COLUMN-LABEL "Conta Patrimonial"
    FIELD ttv_num_bem_pat     AS INTEGER   FORMAT ">>>>>>>>9" INITIAL 0 LABEL "Bem Patrimonial" COLUMN-LABEL "Bem Pat"
    FIELD ttv_num_seq_bem_pat AS INTEGER   FORMAT ">>>>9"     INITIAL 0 LABEL "Sequˆncia Bem"   COLUMN-LABEL "Sequencia"
    FIELD tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    FIELD ttv_dat_trans       AS DATE      FORMAT "99/99/9999" INITIAL ?
    FIELD ttv_situacao        AS CHARACTER FORMAT "x(20)" LABEL "Situa‡Æo"                      COLUMN-LABEL "Situa‡Æo"
    INDEX tt_indice_trans_bem IS PRIMARY UNIQUE
        ttv_num_empresa ASCENDING
        ttv_cod_cta_pat ASCENDING
        ttv_num_bem_pat ASCENDING
        ttv_num_seq_bem_pat ASCENDING.

DEFINE TEMP-TABLE tt_row_errors
    FIELD ttv_num_seq_erro AS INTEGER   FORMAT ">>>>,>>9"
    FIELD ttv_num_erro     AS INTEGER   FORMAT ">>>>,>>9"
    FIELD ttv_des_erro     AS CHARACTER FORMAT "x(50)" LABEL "Incosistˆncia" COLUMN-LABEL "Inconsistˆncia"
    FIELD ttv_des_param    AS CHARACTER FORMAT "x(50)" LABEL "Param"         COLUMN-LABEL "Param"
    FIELD ttv_des_type     AS CHARACTER FORMAT "x(10)"
    FIELD ttv_des_help     AS CHARACTER FORMAT "x(40)" LABEL "Ajuda"         COLUMN-LABEL "Ajuda"
    FIELD ttv_des_sub_type AS CHARACTER FORMAT "x(40)"
    INDEX tt_indice_errors
        ttv_num_seq_erro ASCENDING.

