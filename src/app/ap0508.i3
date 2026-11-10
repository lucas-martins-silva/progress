/*****************************************************************************
**
**  APP/AP0508.I3 - Cria temp-table tt_xml_input_1 para atualiza‡Æo PEF.
**
*****************************************************************************/

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Funcao"
       tt_xml_input_1.tt_des_conteudo    = "{1}" /* "Atualiza Titulo" */
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Empresa"
       tt_xml_input_1.tt_des_conteudo    = string(mov-pef-pend.ep-codigo)
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

find conta-contab
    where conta-contab.ep-codigo      = i-ep-codigo-usuario and
          conta-contab.conta-contabil = mov-pef-pend.conta-contabil
          no-lock no-error.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Conta Contabil"
       tt_xml_input_1.tt_des_conteudo    = string(conta-contab.ct-codigo) + ',' +
                                           string(conta-contab.sc-codigo)
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
       tt_xml_input_1.tt_des_conteudo    = mov-pef-pend.cod-estabel
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Data Movimentacao"
       tt_xml_input_1.tt_des_conteudo    = string(mov-pef-pend.dt-transacao)
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Finalidade Economica"
       tt_xml_input_1.tt_des_conteudo    = string(mov-pef-pend.moeda)
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Valor Movimento"
       tt_xml_input_1.tt_des_conteudo    = string(mov-pef-pend.vl-original)
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Origem Movimento"
       tt_xml_input_1.tt_des_conteudo    = "04" /* AP EMS2 Pendente */
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "ID Movimento"
       tt_xml_input_1.tt_des_conteudo    = string(i-ep-codigo-usuario) + chr(10) +
                                           string(mov-pef-pend.num-id-pef-pend)
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Nova Origem Movimento"
       tt_xml_input_1.tt_des_conteudo    = "05" /* AP EMS2 Titulo */
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

create tt_xml_input_1.
assign tt_xml_input_1.tt_cod_label       = "Novo ID Movimento"
       tt_xml_input_1.tt_des_conteudo    = string(i-ep-codigo-usuario) + chr(10) +
                                           string(mov-ap.num-id-mov-ap)
       tt_xml_input_1.tt_num_seq_1_xml   = v_sequencia
       tt_xml_input_1.tt_num_seq_2_xml   = 1.

/*--- Fim ap0508.i3 ---*/
