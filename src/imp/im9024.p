/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9024 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9024 MIM}
&ENDIF

/****************************************************************************
**
**    IM9024.P - V°nculo da proviss∆o.
**
****************************************************************************/

{app/apapi001b.i}
/***  Sempre que a apapi001.i for utilizada junto com a apapi201.i, a apapi001.i sempre dever† ser definida 
      primeiro e a vari†vel abaixo c-apapi001-inc dever† ser definida(com &scoped-define). Este procedimento
      Ç obrigat¢rio pois as includes definem temp-tables com os mesmos nomes, o que ocasionar† erro de 
      compilaá∆o caso este procedimento n∆o seja efetuado 
 ***/
&scoped-define c-apapi001-inc 

{cdp/cd0666.i} /**** Definiá∆o da temp-table tt-erro ****/

def input        parameter c-seg-usuario like docum-est.usuario.
def input        parameter i-sequencia as integer.
def input-output parameter table for tt-lin-i-ap.
def input-output parameter table for tt-l-pre-ap.
def input-output parameter table for tt-erro.

{imp/im9024.i1} /* Definiá∆o das temp-tables do EMS5 */
    
def var l-erro-ems50  as logical init no.
def var c-msg         as character extent 2 no-undo.
def var c-ref-aux     like lin-i-ap.referencia no-undo.
def var de-disponivel as decimal format "->>>>>,>>>,>>9.99" init 0.

find first tt-lin-i-ap no-lock no-error.

find first param-global no-lock no-error.

if  avail tt-lin-i-ap then do:     

    find first param-imp 
        where param-imp.cod-estabel = tt-lin-i-ap.cod-estabel no-lock no-error.        

    if  avail param-imp then do:    
        find embarque-imp 
            where embarque-imp.cod-estabel = tt-lin-i-ap.cod-estabel 
              and embarque-imp.embarque    = tt-lin-i-ap.nr-docto no-lock no-error.
      
        if  avail embarque-imp and embarque-imp.contabilizado = yes then do:      
        
            create tt_tit_ap_vl_compdo.
            assign tt_tit_ap_vl_compdo.tta_cod_estab           = tt-lin-i-ap.cod-estabel   
                   tt_tit_ap_vl_compdo.tta_cdn_fornecedor      = tt-lin-i-ap.cod-fornec
                   tt_tit_ap_vl_compdo.tta_cod_espec_docto     = param-imp.esp-tit-transit 
                   tt_tit_ap_vl_compdo.tta_cod_ser_docto       = " " 
                   tt_tit_ap_vl_compdo.tta_cod_tit_ap          = tt-lin-i-ap.nr-docto
                   tt_tit_ap_vl_compdo.tta_cod_parcela         = tt-lin-i-ap.parcela
                   tt_tit_ap_vl_compdo.tta_val_comprtdo_tit_ap = 0
                   tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap      = 0.

            assign l-erro-ems50 = no.
    
            if  search("prgfin/apb/apb908za.r")  = ? and
                search("prgfin/apb/apb908za.py") = ? then do:
                    run utp/ut-msgs.p (input "msg",
                                       input 6246,
                                       input "prgfin/apb/apb908za.py").
                    assign l-erro-ems50 = yes.
                    create tt-erro.
                    assign i-sequencia = i-sequencia + 1.
                    assign tt-erro.i-sequen = i-sequencia
                           tt-erro.cd-erro  = 6246
                           tt-erro.mensagem = return-value.                                               
            end.
            else do:                            
                
                if  not l-erro-ems50 then
                    run prgfin/apb/apb908za.py (input 1,
                                                input-output table tt_tit_ap_vl_compdo) .                           
                                                
                find first tt_tit_ap_vl_compdo no-lock no-error.
                
                if  avail tt_tit_ap_vl_compdo and   
                    tt_tit_ap_vl_compdo.ttv_log_existe_tit = yes then do:
                
                    assign de-disponivel = tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap
                                         - tt_tit_ap_vl_compdo.tta_val_comprtdo_tit_ap.                                     
                
                    if  de-disponivel > 0 then do: 
                    
                        create tt-l-pre-ap.
                        assign tt-l-pre-ap.ep-codigo      = tt-lin-i-ap.ep-codigo
                               tt-l-pre-ap.cod-estabel    = tt-lin-i-ap.cod-estabel
                               tt-l-pre-ap.cod-esp        = tt-lin-i-ap.cod-esp
                               tt-l-pre-ap.serie	      = tt-lin-i-ap.serie
                               tt-l-pre-ap.nr-docto       = tt-lin-i-ap.nr-docto
                               tt-l-pre-ap.parcela	      = tt-lin-i-ap.parcela                   
                               tt-l-pre-ap.ep-cod-pre     = param-global.empresa-prin                   
                               tt-l-pre-ap.cod-est-pre    = tt_tit_ap_vl_compdo.tta_cod_estab          
                               tt-l-pre-ap.cod-esp-pre    = tt_tit_ap_vl_compdo.tta_cod_espec_docto 
                               tt-l-pre-ap.serie-pre      = tt_tit_ap_vl_compdo.tta_cod_ser_docto  
                               tt-l-pre-ap.nr-docto-pre   = tt_tit_ap_vl_compdo.tta_cod_tit_ap        
                               tt-l-pre-ap.parcela-pre    = tt_tit_ap_vl_compdo.tta_cod_parcela   
                               tt-l-pre-ap.moeda-pre      = tt-lin-i-ap.mo-codigo
                               tt-l-pre-ap.cod-fornec     = tt_tit_ap_vl_compdo.tta_cdn_fornecedor  
                               tt-l-pre-ap.vl-previsao    =  if  de-disponivel < tt-lin-i-ap.vl-orig-me then
                                                                de-disponivel
                                                            else 
																tt-lin-i-ap.vl-original /*TIFE31*/
                               tt-l-pre-ap.vl-previsao-me = if  de-disponivel < tt-lin-i-ap.vl-orig-me then
                                                                de-disponivel
                                                            else 
                                                                tt-lin-i-ap.vl-orig-me.
                               
                        /* Acerta a diferenáa de saldo entre o t°tulo e a provis∆o */ 
                        if  de-disponivel <> tt-lin-i-ap.vl-orig-me then                        
                            run pi-acerta-dif-prov-tit.                        
                    end.             
                end.
            end.
            
            run pi-limpa-tabelas.
            
        end.    
    end.
end.

/* procedures internas */

Procedure pi-limpa-tabelas:
    for each tt_tit_ap_vl_compdo:
        delete tt_tit_ap_vl_compdo.
    end.

    for each tt_tit_ap_alteracao_base_1:
        delete tt_tit_ap_alteracao_base_1.
    end.
End procedure.  

Procedure pi-acerta-dif-prov-tit:

/*    /* Contabilizar apenas o saldo restante do t°tulo, ou seja, n∆o contabilizar saldo da provis∆o */
 *     for each tt-lin-conta-ap
 *         where tt-lin-conta-ap.ep-codigo   = tt-lin-i-ap.ep-codigo
 *           and tt-lin-conta-ap.cod-estabel = tt-lin-i-ap.cod-estabel
 *           and tt-lin-conta-ap.cod-esp     = tt-lin-i-ap.cod-esp
 *           and tt-lin-conta-ap.serie       = tt-lin-i-ap.serie
 *           and tt-lin-conta-ap.nr-docto    = tt-lin-i-ap.nr-docto
 *           and tt-lin-conta-ap.parcela     = tt-lin-i-ap.parcela
 *           and tt-lin-conta-ap.cod-fornec  = tt-lin-i-ap.cod-fornec :
 *           
 *         delete tt-lin-conta-ap.
 *     end.
 *     
 *     if  de-disponivel <  tt-lin-i-ap.vl-orig-me then do:     
 *     
 *         {rep/re9340.i4 " "} /* cria lin-conta-ap */            
 *         
 *         assign tt-lin-conta-ap.vl-movto     = 0               
 *                tt-lin-conta-ap.vl-movto-me  = tt-lin-i-ap.vl-orig-me
 *                                             - de-disponivel.
 *     end.*/
    
    /* Criar AVA na Provis∆o para zerar o saldo se o mesmo for maior do que o do t°tulo */    
    
    if  de-disponivel >  tt-lin-i-ap.vl-orig-me then do:     
      
        if  search("prgfin/apb/apb767ze.r")  = ? and
            search("prgfin/apb/apb767ze.py") = ? then do:   
            run utp/ut-msgs.p (input "msg",
                              input 6246,
                              input "prgfin/apb/apb767ze.py").
            create tt-erro.
            assign tt-erro.cd-erro  = 6246
                   tt-erro.mensagem = return-value.                        
        end. 
    
        else do:        
        
            run pi-monta-referencia.
            
            CREATE tt_tit_ap_alteracao_base_aux_1.
            ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = c-seg-usuario          
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = ?
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_estab_ext                 = tt-lin-i-ap.cod-estabel 
                   tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor                = tt-lin-i-ap.cod-fornec                  
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto               = param-imp.esp-tit-transit
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                 = " " 
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                    = tt-lin-i-ap.nr-docto
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                   = tt-lin-i-ap.parcela
                   tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = 0
                   tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = ?
                   tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = tt-lin-i-ap.dt-transacao
                   tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = c-ref-aux 
                   tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tt-lin-i-ap.vl-orig-me
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto                = ?
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap             = ?
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto                = ?
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                 = ?
                   tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso               = 0
                   tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso         = 0
                   tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso          = 0
                   tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso     = 0
                   tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                  = ?
                   tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                 = 0
                   tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                  = 0
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                  = ""
                   tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto           = ""
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = ""
                   tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = ?
                   tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "ALTERACAO"
                   tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap                = ""
                   tt_tit_ap_alteracao_base_aux_1.tta_cb4_tit_ap_bco_cobdor         = ""
                   tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto               = "".

            CREATE tt_tit_ap_alteracao_rateio.
            ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap            = ?
                   tt_tit_ap_alteracao_rateio.tta_cod_estab             = ""
                   tt_tit_ap_alteracao_rateio.tta_cod_refer             = ""
                   tt_tit_ap_alteracao_rateio.tta_num_seq_refer         = 0
                   tt_tit_ap_alteracao_rateio.tta_cod_tip_fluxo_financ  = ""
                   tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl    = ""
                   tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl          = ""
                   tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc        = ""
                   tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto      = ""
                   tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap         = 0
                   tt_tit_ap_alteracao_rateio.tta_num_id_aprop_ctbl_ap  = ?
                   tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat           = "Valor".
            
            run prgfin/apb/apb767ze.py(input 1,
                                       input "Rep",
                                       input "",
                                       input-output table tt_tit_ap_alteracao_base_aux_1,
                                       input-output table tt_tit_ap_alteracao_rateio,
                                       output table tt_log_erros_tit_ap_alteracao).
            
            for each tt_log_erros_tit_ap_alteracao:
                
                {utp/ut-field.i mgind dupli-apagar nro-docto 1} 
                assign c-msg[1] = return-value.
                {utp/ut-liter.i EMS5 MRE R}
                assign c-msg[1] = c-msg[1] + " " + return-value.
      
                create tt-erro.
                assign tt-erro.cd-erro  = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem 
                       tt-erro.mensagem =  c-msg[1] + " " 
                                        + tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap
                                        + " " 
                                        + tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro.
            end. 
        end.
    end.
End procedure.      

Procedure pi-monta-referencia:  
    assign c-ref-aux = string(day(today),"99") +
                       if  month(today) < 10 then 
                           string(month(today),"9")
                                 + substr(string(time,"hh:mm"),1,2)
                                 + substr(string(time,"hh:mm"),4,2)
                                 + substr(string(time,"hh:mm:ss"),7,2)
                                 + "1"
                       else 
                           entry(month(today) - 9,"A,B,C")
                                + substr(string(time,"hh:mm"),1,2)
                                + substr(string(time,"hh:mm"),4,2)
                                + substr(string(time,"hh:mm:ss"),7,2)
                                + "1".
End procedure.               

