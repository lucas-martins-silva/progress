/*-------------------------------------------------------------------------------
** app/ap1002b.i - Defini‡Æo das temp-tables do EDI
-------------------------------------------------------------------------------*/

def temp-table tt_processos_edi        
   field tta_cdn_proces_edi             as int  format ">>>>>>>9" init 0 label "Processo" column-label "Processo"
   field tta_ind_sit_proces_edi         as char format "X(10)" init "Ativo" label "Situa‡Æo Processo" column-label "Situa‡Æo Processo"
   field tta_cdn_parcei_edi             as int  format ">>>>>9" init 0 label "Parceiro" column-label "Parceiro"
   field tta_des_parcei_edi             as char format "x(40)" label "Parceiro EDI" column-label "Descri‡Æo"
   field tta_dat_gerac_proces_edi       as date format "99/99/9999" init today label "Data Gera‡Æo" column-label "Data Gera‡Æo"
   field tta_hra_gerac_proces_edi       as char format "99:99:99" label "Hora Gera‡Æo" column-label "Hora Gera‡Æo"
   field tta_cod_usuar_gerac_proces_edi as char format "x(12)" label "Usu rio Gera‡Æo" column-label "Usu rio Gera‡Æo"
   field ttv_log_selec_edi              as log  format "Sim/NÆo" init no label "Selecionado" column-label "Selecionado".

def temp-table tt_dados_efetiv_edi        
   field tta_cdn_proces_edi             as int  format ">>>>>>>9" init 0 label "Processo" column-label "Processo"
   field tta_cdn_segment_edi            as int  format ">>>>>9" init 0 label "Segmento" column-label "Segmento"
   field tta_cdn_seq_reg_proces_edi     as int  format ">>>>>9" init 0 label "Sequˆncia Registro P" column-label "Sequˆncia Registro P"
   field tta_des_id_reg_bloco_modul_edi as char format "x(60)" label "Id Registro Bloco" column-label "Id Registro Bloco"
   field tta_cod_id_bloco_edi           as char format "x(15)" label "Id Bloco EDI" column-label "Id Bloco EDI"
   field tta_dsl_dados_edi              as char format "x(15000)" label "Dados EDI" column-label "Dados EDI"
   field tta_ind_dados_ok_edi           as char format "X(09)" label "Dados Ok Electronic" column-label "Dados Ok Electronic".

def temp-table tt_erros_efetiv_edi        
   field tta_cdn_proces_edi         as int  format ">>>>>>>9" init 0 label "Processo" column-label "Processo"
   field tta_cdn_seq_reg_proces_edi as int  format ">>>>>9" init 0 label "Sequˆncia Registro P" column-label "Sequˆncia Registro P"
   field tta_des_erro_efetivac_edi  as char format "x(60)" label "Erro Efetiva‡Æo Elec" column-label "Erro Efetiva‡Æo Elec".

def temp-table tt_identif_efetiv_edi        
   field tta_cdn_mapa_edi   as int format ">>>>>9"   init 0 label "Mapa"     column-label "Mapa"
   field tta_cdn_parcei_edi as int format ">>>>>9"   init 0 label "Parceiro" column-label "Parceiro"
   field tta_cdn_proces_edi as int format ">>>>>>>9" init 0 label "Processo" column-label "Processo".

def temp-table tt_objetos_defaults        
   field ttv_cod_usuar_corren         as char format "x(12)" label "Usu rio Corrente" column-label "Usu rio Corrente"
   field ttv_cod_usuar_corren_criptog as char format "x(16)"
   field ttv_cod_modul_dtsul_corren   as char format "x(3)" label "M¢dulo Corrente" column-label "M¢dulo Corrente"
   field ttv_cod_aplicat_dtsul_corren as char format "x(3)"
   field ttv_cod_empres_usuar         as char format "x(3)" label "Empresa" column-label "Empresa"
   field ttv_cod_estab_usuar          as char format "x(3)" label "Estabelecimento" column-label "Estab"
   field ttv_cod_idiom_usuar          as char format "x(8)" label "Idioma" column-label "Idioma"
   field ttv_cod_unid_negoc_usuar     as char format "x(3)" label "Unidade Neg¢cio" column-label "Unid Neg¢cio"
   field ttv_cod_pais_empres_usuar    as char format "x(3)" label "Pa¡s Empresa Usu rio" column-label "Pa¡s"
   field ttv_cod_funcao_negoc_empres  as char format "x(50)"
   field ttv_cod_modul_dtsul_empres   as char format "x(100)"
   field ttv_cod_plano_ccusto_corren  as char format "x(8)" label "Plano CCusto" column-label "Plano CCusto"
   field ttv_cod_grp_usuar_lst        as char format "x(3)" label "Grupo Usu rios" column-label "Grupo"
   field ttv_cod_dwb_user             as char format "x(12)" label "Usu rio" column-label "Usu rio"
   field ttv_num_ped_exec_corren      as int  format ">>>>9".

def temp-table tt_variaveis_api_edi        
    field ttv_num_vers_integr_api          as integer format ">>>>,>>9"
    field ttv_cdn_trans_edi                as Integer format ">>>>>9" label "Transa‡Æo" column-label "Transa‡Æo"
    field ttv_cdn_parcei_edi               as Integer format ">>>>>9" label "Parceiro" column-label "Parceiro"
    field ttv_cod_erro_vers_integr_api     as character format "x(8)"
    field ttv_ind_exec_modul_edi           as character format "X(08)"
    field tta_ind_forma_import_edi         as character format "X(20)" label "Importa‡Æo" column-label "Forma Importa‡Æo".
  
def temp-table tt_layout_msg_pagto 
   field cod_parcei_edi          as int  format ">>>>>9"
   field cod_proces_edi          as int  format ">>>>>>>9" init 0
   field cod_id_bloco_msg_edi    as char format "x(60)"
   field cdn_tip_reg_msg_edi     as int  format "9" init 0     
   field num_remes_msg_edi       as int  format "9999999"
   field tp_arq_codigo           as int  format "9"
   field cod_banco               like banco.cod-banco
   field nome_banco              like banco.nome-banco
   field agencia_bcia            as int  format "99999"
   field conta_corren            as int  format "999999999999"
   field tp_inscr_empr           as int  format "9"
   field nr_inscr_empr           as char format "x(14)"
   field tp_registro             as int  format "9"
   field nome_empresa            as char format "x(30)"
   field end_empresa             as char format "x(50)"
   field cidade_empresa          as char format "x(20)"
   field cep_empresa             as char format "x(08)"
   field estado_empresa          as char format "x(02)"
   field nr_lote_msg_edi         as int  format "9999"
   field nr_seq_reg              as int  format "99999"
   field cod_segmento            as char format "x(01)"
   field nome_fav                as char format "x(30)"
   field cod_banco_fav           like banco.cod-banco
   field tp_pagto                as int  format "99"
   field forma_pagto             as int  format "99"
   field tp_movto                as int  format "999"
   field seu_numero              as char format "x(20)"          
   field nosso_numero            as char format "x(15)"
   field dt_prev_pagto           as date format "99999999"
   field vlr_pagto               as dec  format "999999999999999"
   field dt_efetiv_pagto         as date format "99999999"
   field vlr_efetiv_pagto        as dec  format "999999999999999"
   field vlr_desconto            as dec  format "999999999999999"
   field vlr_acrescimo           as dec  format "999999999999999"
   field ocorr_retorno           as char format "x(10)"
   index tt_header                       
         cod_parcei_edi               ascending
         num_remes_msg_edi            ascending.

def temp-table tt_erros_api_recebto_msg_pagto no-undo
   field ttv_cod_id_bloco_msg_edi as char format "x(60)"
   field ttv_num_msg_erro         as int  format ">>>>>>9" label "Mensagem" column-label "Mensagem"
   field ttv_des_msg_erro         as char format "x(60)" label "Mensagem Erro" column-label "Mensagem Erro"
   field tta_cod_estab_bord       as char format "x(3)" label "Estabelecimento" column-label "Estab"
   field tta_num_id_item_bord_ap  as int  format ">>>>,>>9" init 0 label "Id Item Bord" column-label "Id Item Bord"
   field tta_num_seq_ocor_bcia    as int  format ">9" init 0 label "Sequˆncia" column-label "Sequˆncia"
   field tta_ind_tip_ocor_bcia    as char format "x(40)" label "Tipo Ocor Bancia" column-label "Tipo Ocor Bancia".

def temp-table tt_tit_pagto_escr        
   field tta_cdn_fornecedor    as int  format ">>>,>>>,>>9" init 0 label "Fornecedor" column-label "Fornecedor"
   field tta_cod_estab         as char format "x(3)" label "Estabelecimento" column-label "Estab"
   field tta_cod_espec_docto   as char format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
   field tta_cod_ser_docto     as char format "x(3)" label "S‚rie Documento" column-label "S‚rie"
   field tta_cod_tit_ap        as char format "x(10)" label "T¡tulo" column-label "T¡tulo"
   field tta_cod_parcela       as char format "x(02)" label "Parcela" column-label "Parc"
   field tta_dat_emis_docto    as date format "99/99/9999" init today label "Data  EmissÆo" column-label "Dt EmissÆo"
   field tta_dat_vencto_tit_ap as date format "99/99/9999" init today label "Data Vencimento" column-label "Dt Vencto"
   field ttv_dat_movto         as date format "99/99/9999"
   field tta_val_movto_ap      as dec  format "->>>,>>>,>>9.99" decimals 2 init 0 label "Valor  Movimento" column-label "Valor Movto"
   field tta_num_bord_ap       as int  format ">>>>>9" init 0 label "N£mero Border“" column-label "Border“"
   field tta_cod_tit_ap_bco    as char format "x(20)" label "T¡tulo  Banco" column-label "T¡tulo Banco"
   field ttv_cod_trans         as char format "x(12)" label "Transa‡Æo" column-label "Transa‡Æo"
   field ttv_des_observacao    as char format "x(65)" label "Observa‡Æo" column-label "Observa‡Æo"
   field ttv_log_liquidac      as log  format "Sim/NÆo" init no.

def temp-table tt_erros_modulo
   field num_sequencia_erro as int  format "9999"
   field cod_erro           as int  format "99999"
   field des_erro           as char format "x(120)"
   field cod_processo       as int  format ">>>>>9"
   field cod_estab          like titulo.cod-estabel
   field cod_esp            like titulo.cod-esp
   field nr_docto           like titulo.nr-docto
   field parcela            like titulo.parcela
   field serie              like titulo.serie.  

def temp-table tt-ocorrencias
   field cod-ocorrencia  as char format "x(02)" 
   field cod-banco       like banco.cod-banco
   field cod-tipo-ocor   like ocor-bcia-bco.ind-tip-ocor-bcia
   field desc-tipo-ocor  as char format "x(25)"   
   field portador        like portador.cod-portador
   field modalidade      like portador.modalidade
   field cod-estabel     like titulo.cod-estabel
   field cod-esp         like titulo.cod-esp
   field nr-docto        like titulo.nr-docto
   field parcela         like titulo.parcela
   field serie           like titulo.serie.   

define temp-table tt-raw-detalhe
    field raw-detalhe as raw.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table tt-raw-erros-modulo
   field raw-erros-modulo  as raw.
       
define temp-table tt-raw-ocorrencias
    field raw-ocorrencias  as raw.
       
/* app/ap1002b.i */
