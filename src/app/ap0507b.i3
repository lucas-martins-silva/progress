DEFINE TEMP-TABLE TT-COMIS
  field cod_empresa               as char  format "x(3)"
  field cdn_repres                as inte  format ">>>,>>9"            init 0
  field cod_indic_econ            as char  format "x(8)"
  field cod_classif               as char  format "x(8)"
  field num_id_movto_comis        as inte  format "9999999999"         init 0
  field cod_estab                 as char  format "x(3)"
  field num_id_tit_acr            as inte  format "9999999999"         init 0
  field num_id_movto_tit_acr      as inte  format "9999999999"         init 0
  field cod_refer                 as char  format "x(10)"
  field cod_usuario               as char  format "x(12)"
  field dat_emis_comis            as date  format "99/99/9999"         init today
  field dat_prev_liquidac         as date  format "99/99/9999"         init today
  field hra_gerac_movto           as char  format "99:99:99"
  field idi_orig_movto_comis      as inte  format ">9"                 init 1
  field num_id_movto_tit_ap       as inte  format "9999999999"         init ?
  field idi_sit_movto_comis       as inte  format ">9"                 init 1
  field idi_tip_movto             as inte  format ">9"                 init 1
  field idi_lancto                as inte  format ">9"                 init 1
  field val_base_calc_comis       as deci  format ">>>,>>>,>>9.99"     init 0
  field val_movto_comis           as deci  format "->>,>>>,>>>,>>9.99" init 0
  field val_orig_movto_comis      as deci  format "->>,>>>,>>>,>>9.99" init 0
  field cdn_cliente               as inte  format ">>>,>>>,>>9"        init 0
  field cod_espec_docto           as char  format "x(3)"
  field cdn_motiv_movto_comis     as inte  format ">>>9"               init 0
  field cod_unid_negoc            as char  format "x(3)"
  field des_histor_movto_comis    as char  format "x(2000)"
  field num_id_movto_vincul       as inte  format "9999999999"         init ?
  field cod_livre_1               as char  format "x(100)"
  field serie                     as char  format "x(5)"
  field nr-docto                  as char  format "x(16)"
  field parcela                   as char  format "x(2)"
  field vl-saldo                  as deci  format "->>,>>>,>>>,>>9.99" init 0.
