/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0704 2.00.00.022 } /*** 010022 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0704 MBC}
&ENDIF
/* Comentario inserido para validar corre‡äes de dicionario de dados efetuadas atraves do chamado TTQYHI*/
/*******************************************************************************
**
**   Programa..: bc0704.p
**
**   Parƒmetros: rowid da agenda-rpw que est  sendo executada
**
**   VersÆo....: 02.00.00 - Luciano
**
**   Objetivo..: Prepara pr¢ximo pedido de execu‡Æo
**
*********************************************************************************/
/* {btb/btb912zb.i}*/  
{include/i_dbinst.i}
{include/i_dbtype.i}
{btb/btb912zc.i2}
{utp/ut-glob.i}
/*******************************Parƒmetros de Entrada****************************/
 define input parameter r-agenda-rpw as rowid no-undo.

/******************************Defini‡Æo de Vari veis****************************/
 def new global shared var v_cod_aplicat_dtsul_corren as character format "x(3)"  no-undo.
 def new global shared var v_cod_grp_usuar_lst        as character format "x(3)"  no-undo.
 def new global shared var v_cod_idiom_usuar          as character format "x(8)"  no-undo.
 def new global shared var v_cod_pais_empres_usuar    as character format "x(3)"  no-undo.
 def new global shared var v_cod_usuar_corren         as character format "x(12)" no-undo.
 def new global shared var v_cod_usuar_corren_criptog as character format "x(16)" no-undo.
 def new global shared var l-agenda                   as logical   initial no     no-undo.

 define variable i-dia-exec      as integer no-undo.
 define variable i-mes-exec      as integer no-undo.
 define variable i-ano-exec      as integer no-undo.
 define variable i-dia-ult-exec  as integer no-undo.
 define variable i-cont          as integer no-undo.
 define variable i-divisor       as integer no-undo.
 define variable da-exec         as integer no-undo.
 define variable hr-exec         as char    no-undo.
 define variable dat-prox-exec   as date    no-undo.
 define variable hra-prox-exec   as char    no-undo.
 define variable c-erro          as char    no-undo format "x(100)" initial "".
 define variable i-hora          as int     no-undo.
 define variable c-arquivo       as char    no-undo.
 define variable c-versao        as char    no-undo.
 define variable c-mensagem      as char    no-undo.
 define variable v-des-inf-aplic as char    no-undo.
 define variable v-hdl-api       as handle  no-undo.


 define variable c-hora like horar_rpw.hra_exec no-undo. 

/*****************************Defini‡Æo de TempTables****************************/

{bcp/bc0204.i}

/************************************Main Block**********************************/
 find agenda_rpw where rowid(agenda_rpw) = r-agenda-rpw no-lock no-error.

 if  not avail agenda_rpw then do:
     {utp/ut-table.i emsfnd agenda_rpw 1}
     run utp/ut-msgs.p (input "msg",
                        input 56,
                        input return-value).
     assign c-erro = "56 - " + return-value.
     return c-erro.
 end.
 if  not agenda_rpw.log_sit_rpw then do:
     {utp/ut-table.i emsfnd agenda_rpw 1}
     run utp/ut-msgs.p (input "msg",
                        input 469,
                        input return-value).
     assign c-erro = "469 - " + return-value.
     return c-erro.
 end.
 assign da-exec = day(today)
        hr-exec = string(time,"hh:mm:ss").

 
 if  agenda_rpw.idi_tip_calend = 1 then run pi-trata-calendario-mensal.
 if  agenda_rpw.idi_tip_calend = 2 then run pi-trata-calendario-quinzenal.
 if  agenda_rpw.idi_tip_calend = 3 then run pi-trata-calendario-semanal. 

 if  c-erro <> "" then return c-erro.

 run pi-cria-temptables.

 rpw:
 do on error  undo rpw, leave rpw
    on quit   undo rpw, leave rpw
    on stop   undo rpw, leave rpw
    on endkey undo rpw, leave rpw:

    run btb/btb912zc.p persistent set v-hdl-api.

    run pi-execute-2 in v-hdl-api (input-output table tt_param_segur,
                                   input-output table tt_ped_exec_aux_2,
                                   input        table tt_ped_exec_param,
                                   input        table tt_ped_exec_param_aux,
                                   input        table tt_ped_exec_sel,
                                   output       table tt_erros_envio_email).
    delete procedure v-hdl-api.

 end.
 if  (error-status:error          = yes and
      error-status:get-number(1) <> 565 and
      error-status:get-number(1) <> 138 and
      error-status:get-number(1) <> 91)  or
     (error-status:get-number(1) <> 565 and
      error-status:get-number(1) <> 138 and
      error-status:get-number(1) <>  91 and
      error-status:num-messages <> 0) 
 then do:
      assign c-erro = error-status:get-message(1).
      return c-erro.
 end. 

 if  return-value = "NOK" then do:
     find first tt_param_segur no-lock no-error.
     if  avail tt_param_segur and
         tt_param_segur.ttv_num_msg_erro <> 0 then do:
         assign c-erro = string(tt_param_segur.ttv_num_msg_erro) + " - " +
                         tt_param_segur.ttv_des_msg.
         return c-erro.
     end.
     else do:
         find first tt_ped_exec_aux_2 no-lock no-error.
         if  avail tt_ped_exec_aux_2 and
             tt_ped_exec_aux_2.ttv_num_msg_erro <> 0 then do:
             assign c-erro = string(tt_ped_exec_aux_2.ttv_num_msg_erro) + " - " +
                             tt_ped_exec_aux_2.ttv_cod_msg_parameters.
             return c-erro.
         end.
     end.
 end.



 find first tt_ped_exec_aux_2 no-lock no-error.
 if  avail tt_ped_exec_aux_2 then do:
     if  i-num-ped-exec-rpw = 0 then 
         run utp/ut-msgs.p (input "show",
                            input 15484,
                            input string(tt_ped_exec_aux_2.tta_num_ped_exec) + "~~" +
                            tt_ped_exec_aux_2.tta_cod_servid_exec).

/*     /* Denis */
 *     find ped_exec where
 *          ped_exec.num_ped_exec = tt_ped_exec_aux_2.tta_num_ped_exec
 *          EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
 * 
 *     if  avail ped_exec 
 *     and locked(ped_exec) = NO
 *     then
 *         assign  ped_exec.log-1 = YES.
 * 
 *     release ped_exec.
 *      /* Denis */*/

 end.


 find agenda_rpw where rowid(agenda_rpw) = r-agenda-rpw exclusive-lock no-error.
 assign agenda_rpw.dat_ult_exec = dat-prox-exec
        agenda_rpw.hra_ult_exec = hra-prox-exec
        agenda_rpw.num_ult_ped_progdo = if  avail tt_ped_exec_aux_2
                                        THEN tt_ped_exec_aux_2.tta_num_ped_exec
                                        ELSE 0.
 return "OK".

/*******************************Procedure Definition***********************************/ 
 Procedure pi-trata-calendario-mensal:
    assign i-mes-exec = month(today)
           i-ano-exec = year(today)
           i-cont     = 0.
    loop:
    repeat:
        find first horar_rpw where
                   horar_rpw.cdn_modul_refer = agenda_rpw.cdn_modul_refer      and
                   horar_rpw.cdn_operac     = agenda_rpw.cdn_operac    and
                   horar_rpw.cdn_maq_dest   = agenda_rpw.cdn_maq_dest and
                   horar_rpw.cod_trans_mp   = agenda_rpw.cod_trans_mp    and
                   horar_rpw.cod_trans_cld  = agenda_rpw.cod_trans_cld    and
                   horar_rpw.cdn_trans_edi  = agenda_rpw.cdn_trans_edi   and
                   horar_rpw.num_parcei_edi = agenda_rpw.num_parcei_edi    and
                   horar_rpw.num_dia_exec       = da-exec                and
                   horar_rpw.hra_exec       > hr-exec no-lock no-error.

        if  not avail horar_rpw then do:
            find first horar_rpw where
                       horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
                       horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
                       horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
                       horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
                       horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
                       horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
                       horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi    and
                       horar_rpw.num_dia_exec   > da-exec                 no-lock no-error.
        end.
        if  not avail horar_rpw then do:
            find first horar_rpw where
                       horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
                       horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
                       horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
                       horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
                       horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
                       horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
                       horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi no-lock no-error.
            if  not avail horar_rpw then do:
                {utp/ut-table.i emsfnd horar_rpw 1}
                run utp/ut-msgs.p (input "msg",
                                   input 56,
                                   input return-value).
                assign c-erro = "56 - " + return-value.
                return c-erro.
            end.
            assign i-mes-exec = i-mes-exec + 1.
            if  i-mes-exec > 12 then do:
                assign i-mes-exec = 01
                       i-ano-exec = i-ano-exec + 1.
            end.
        end.
        assign i-dia-exec = horar_rpw.num_dia_exec.
        if  i-mes-exec = 02 then do:
            assign i-divisor = if (i-ano-exec modulo 100) = 0 then 400 else 4.
            if  (i-ano-exec modulo i-divisor) = 0 then do:  /* Ano Bissexto     */
                if  i-dia-exec <= 29 then leave loop.
            end.
            else do:                                        /* Ano nÆo Bissexto */
                if  i-dia-exec <= 28 then leave loop.
            end.
        end.
        else do:
            if  (i-mes-exec = 04) or (i-mes-exec = 06) or 
                (i-mes-exec = 09) or (i-mes-exec = 11) then do:
                if  i-dia-exec <= 30 then leave loop.
            end.
            else leave loop.
        end.
        i-cont = i-cont + 1.
        assign da-exec = day(today + i-cont)
               hr-exec = "00:00:00".
        assign i-dia-ult-exec = day(today + i-cont)
               i-mes-exec     = month(today + i-cont)
               i-ano-exec     = year(today + i-cont).
        next loop.
    end.
    assign dat-prox-exec = date(i-mes-exec,i-dia-exec,i-ano-exec)
           hra-prox-exec = replace(horar_rpw.hra_exec,":","").
 End Procedure.

 Procedure pi-trata-calendario-quinzenal:
    assign i-dia-ult-exec = day(today)
           i-mes-exec     = month(today)
           i-ano-exec     = year(today)
           i-cont         = 0.
    loop:
    repeat:
        if da-exec > 15 then assign da-exec = da-exec - 15.
        find first horar_rpw where
                   horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
                   horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
                   horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
                   horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
                   horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
                   horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
                   horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi    and
                   horar_rpw.num_dia_exec    = da-exec                and
                   horar_rpw.hra_exec   > hr-exec no-lock no-error.

        if  not avail horar_rpw then do:
            find first horar_rpw where
                       horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
                       horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
                       horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
                       horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
                       horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
                       horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
                       horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi    and
                       horar_rpw.num_dia_exec    > da-exec no-lock no-error.
        end.
        if  not avail horar_rpw then do:
            find first horar_rpw where
                       horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
                       horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
                       horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
                       horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
                       horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
                       horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
                       horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi no-lock no-error.
            if  not avail horar_rpw then do:
                {utp/ut-table.i emsfnd horar_rpw 1}
                run utp/ut-msgs.p (input "msg",
                                   input 56,
                                   input return-value).
                assign c-erro = "56 - " + return-value.
                return c-erro.
            end.
            if  i-dia-ult-exec > 15 then do:
                assign i-dia-exec = horar_rpw.num_dia_exec.
                assign i-mes-exec = i-mes-exec + 1.
                if  i-mes-exec > 12 then do:
                    assign i-mes-exec = 01
                           i-ano-exec = i-ano-exec + 1.
                end.
            end.
            else assign i-dia-exec = horar_rpw.num_dia_exec + 15.
        end.
        else do:
            if  i-dia-ult-exec > 15 then do:
                assign i-dia-exec = horar_rpw.num_dia_exec + 15.
            end.
            else assign i-dia-exec = horar_rpw.num_dia_exec.
        end.
        if  i-mes-exec = 02 then do:
            assign i-divisor = if (i-ano-exec modulo 100) = 0 then 400 else 4.
            if  (i-ano-exec modulo i-divisor) = 0 then do:  /* Ano Bissexto     */
                if  i-dia-exec <= 29 then leave loop.
            end.
            else do:                                        /* Ano nÆo Bissexto */
                if  i-dia-exec <= 28 then leave loop.
            end.
        end.
        else do:
            if  (i-mes-exec = 04) or (i-mes-exec = 06) or 
                (i-mes-exec = 09) or (i-mes-exec = 11) then do:
                if  i-dia-exec <= 30 then leave loop.
            end.
            else leave loop.
        end.
        i-cont = i-cont + 1.
        assign da-exec = day(today + i-cont)
               hr-exec = "00:00:00".  
        assign i-dia-ult-exec = day(today + i-cont)
               i-mes-exec     = month(today + i-cont)
               i-ano-exec     = year(today + i-cont).
        next loop.
    end.
    assign dat-prox-exec = date(i-mes-exec,i-dia-exec,i-ano-exec)
           hra-prox-exec = replace(horar_rpw.hra_exec,":","").
 End Procedure.

 Procedure pi-trata-calendario-semanal:
    assign da-exec = weekday(today). 
    find next horar_rpw where
              horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
              horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
              horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
              horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
              horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
              horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
              horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi    and
              horar_rpw.num_dia_exec    = da-exec                and
              horar_rpw.hra_exec   > hr-exec no-lock no-error.
    if  not avail horar_rpw then do:
        find first horar_rpw where
                   horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
                   horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
                   horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
                   horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
                   horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
                   horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
                   horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi    and
                   horar_rpw.num_dia_exec    > da-exec no-lock no-error.
    end.
    if  not avail horar_rpw then do:
        find first horar_rpw where
                   horar_rpw.cdn_modul_refer      = agenda_rpw.cdn_modul_refer      and
                   horar_rpw.cdn_operac    = agenda_rpw.cdn_operac    and
                   horar_rpw.cdn_maq_dest = agenda_rpw.cdn_maq_dest and
                   horar_rpw.cod_trans_mp    = agenda_rpw.cod_trans_mp    and
                   horar_rpw.cod_trans_cld    = agenda_rpw.cod_trans_cld    and
                   horar_rpw.cdn_trans_edi   = agenda_rpw.cdn_trans_edi   and
                   horar_rpw.num_parcei_edi    = agenda_rpw.num_parcei_edi no-lock no-error.
        if  not avail horar_rpw then do:
            {utp/ut-table.i emsfnd horar_rpw 1}
            run utp/ut-msgs.p (input "msg",
                               input 56,
                               input return-value).
            assign c-erro = "56 - " + return-value.
            return c-erro.
        end.
    end.

    if  (horar_rpw.num_dia_exec = weekday(today) and
         horar_rpw.hra_exec < string(time,"HH:MM:SS")) then
        assign dat-prox-exec = today + 1.
    else 
        assign dat-prox-exec = today.

    loop:
    repeat:
        if  weekday(dat-prox-exec) = horar_rpw.num_dia_exec then leave loop.
        dat-prox-exec = dat-prox-exec + 1.
        next loop.
    end.
    assign hra-prox-exec = replace(horar_rpw.hra_exec,":","").
 End Procedure. 

 Procedure pi-cria-temptables:

    find first param-bc no-lock no-error.

    for each tt_param_segur:
        delete tt_param_segur.
    end.

    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 003
           tt_param_segur.tta_cod_aplicat_dtsul_corren = v_cod_aplicat_dtsul_corren
           tt_param_segur.tta_cod_empres_usuar         = i-ep-codigo-usuario
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = v_cod_idiom_usuar
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MCL"
           tt_param_segur.tta_cod_pais_empres_usuar    = v_cod_pais_empres_usuar
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

    for each tt_ped_exec_aux_2:
        delete tt_ped_exec_aux_2.
    end.

/*NOVO ****************************/
    assign  c-mensagem  = ( if  agenda_rpw.cdn_operac = 1     /* Atualiza‡Æo */
                            then    if  agenda_rpw.cod_trans_cld = ""
                                    then "Atualiza‡Æo de Todas as Transa‡äes"
                                    else "Atualiza‡Æo da Transa‡Æo"
                            else    if  agenda_rpw.cod_trans_cld = ""
                                    then "Importa‡Æo de Todas os Coletores"
                                    else "Importa‡Æo do Coletor").

    run utp/ut-liter.p (input c-mensagem,
                        input "MBC",
                        input "R") no-error.

    assign  v-des-inf-aplic =       return-value
                                +   (   if agenda_rpw.cod_trans_cld <> ""
                                        then " - (" + agenda_rpw.cod_trans_cld + ") "
                                        else "").

    IF agenda_rpw.cdn_operac = 1 THEN DO:
        IF agenda_rpw.num_parcei_edi = 0 THEN
            {utp/ut-liter.i "Movimento e Etiqueta" * L}
        IF agenda_rpw.num_parcei_edi = 1 THEN
            {utp/ut-liter.i Movimento * L}
        IF agenda_rpw.num_parcei_edi = 2 THEN
            {utp/ut-liter.i Etiqueta * L}
        ASSIGN v-des-inf-aplic = v-des-inf-aplic + " - ":U + TRIM(RETURN-VALUE).
    END.

/*NOVO ****************************/
    create tt_ped_exec_aux_2.
    assign tt_ped_exec_aux_2.tta_num_seq                = 1
           tt_ped_exec_aux_2.tta_num_ped_exec           = 0 
           tt_ped_exec_aux_2.tta_cod_usuario            = c-seg-usuario
           tt_ped_exec_aux_2.tta_dat_exec_ped_exec      = dat-prox-exec
           tt_ped_exec_aux_2.tta_cod_servid_exec        = (if  agenda_rpw.cdn_operac = 1 
                                                     then param-bc.cod_servid_exec_atualiz
                                                     else param-bc.cod_servid_exec_import)
           tt_ped_exec_aux_2.tta_cdn_estil_dwb          = 97
           tt_ped_exec_aux_2.tta_cod_orig_ped_exec      = "CL".
           tt_ped_exec_aux_2.ttv_des_inf_aplic          = v-des-inf-aplic.
           tt_ped_exec_aux_2.ttv_log_envia_email        = YES.


    if  agenda_rpw.cdn_operac = 1 then
        assign  tt_ped_exec_aux_2.tta_cod_prog_dtsul_rp = "bcp/bc0204rp.p"
                tt_ped_exec_aux_2.tta_cod_prog_dtsul    = "bc0204".
    else
        assign  tt_ped_exec_aux_2.tta_cod_prog_dtsul_rp = "bcp/bc0601rp.p"
                tt_ped_exec_aux_2.tta_cod_prog_dtsul    = "bc0601".

    assign c-arquivo = substring(tt_ped_exec_aux_2.tta_cod_prog_dtsul_rp, 1, 13) + "r".
    run utp/ut-vrbin.p (input c-arquivo,
                        input yes,
                        output c-versao).
    if  c-versao <> ? then 
        assign tt_ped_exec_aux_2.tta_cod_release_prog_dtsul = c-versao.  
    else
        assign tt_ped_exec_aux_2.tta_cod_release_prog_dtsul = "0.00.00.000".

    assign c-hora = horar_rpw.hra_exec.
    repeat:
        find ped_exec no-lock
             where ped_exec.cod_usuario       = c-seg-usuario
               and ped_exec.cod_prog_dtsul    = tt_ped_exec_aux_2.tta_cod_prog_dtsul
               and ped_exec.dat_exec_ped_exec = dat-prox-exec
               and ped_exec.hra_exec_ped_exec = replace(c-hora, ":", "") no-error.
        if  avail ped_exec then do:
            i-hora = integer(substr(c-hora, 7, 2)). /* separa os segundos */
            i-hora = i-hora + (integer(substring(c-hora, 4, 2)) * 60). /* separa os minutos */
            i-hora = i-hora + (integer(substring(c-hora, 1, 2)) * 60 * 60). /* separa as horas */
            i-hora = i-hora + 1.
            c-hora = string(i-hora, "hh:mm:ss").
        end.
        else do:
            assign tt_ped_exec_aux_2.tta_hra_exec_ped_exec = replace(c-hora, ":", ""). 
            leave.
        end.
    end.
    for each tt-param:
        delete tt-param.
    end.
    create  tt-param.
    assign  tt-param.destino      = 2
            tt-param.arquivo      = "BC0204.txt"
            tt-param.arq-destino  = "BC0601.txt"
            tt-param.usuario      = c-seg-usuario
            tt-param.data-exec    = today
            tt-param.hora-exec    = time
            tt-param.ep-codigo    = i-ep-codigo-usuario
            tt-param.tp-trans-ini = agenda_rpw.cod_trans_cld
            tt-param.tp-trans-fim = if agenda_rpw.cod_trans_cld = ""
                                   then "ZZZZZZZZ"
                                   else agenda_rpw.cod_trans_cld
            tt-param.da-ini       = 01/01/1900
            tt-param.da-fim       = 12/31/9999
            tt-param.trans-ini    = 0
            tt-param.trans-fim    = 9999999999
            tt-param.hr-ini       = "00:00:00"
            tt-param.hr-fim       = "23:59:59"
            tt-param.todos        = 2
            tt-param.coletor-ini  = if  agenda_rpw.cdn_operac = 2
                                    then agenda_rpw.cod_trans_cld
                                    else ""
            tt-param.coletor-fim  = if  agenda_rpw.cdn_operac = 2
                                    then
                                        if   agenda_rpw.cod_trans_cld = ""
                                        then "ZZZZZZZZ"
                                        else agenda_rpw.cod_trans_cld
                                     else "ZZZZZZZZ".

    IF agenda_rpw.cdn_operac = 1 THEN DO:
        IF agenda_rpw.num_parcei_edi = 0 THEN
            ASSIGN tt-param.tp-etiqueta  = yes
                   tt-param.tp-movto     = yes.
        ELSE
            IF agenda_rpw.num_parcei_edi = 1 THEN
                ASSIGN tt-param.tp-etiqueta  = NO
                       tt-param.tp-movto     = YES.
            ELSE
                IF agenda_rpw.num_parcei_edi = 2 THEN
                    ASSIGN tt-param.tp-etiqueta  = yes
                           tt-param.tp-movto     = NO.
    END.
    ELSE
        IF agenda_rpw.cdn_operac = 2 THEN
            ASSIGN tt-param.tp-etiqueta  = yes
                   tt-param.tp-movto     = yes.
    
    IF NUM-ENTRIES(agenda_rpw.cod_trans_mp,CHR(10)) = 2 THEN DO:
        IF entry(1,agenda_rpw.cod_trans_mp,CHR(10)) = "yes":U THEN tt-param.tp-estado-nova = YES.
        IF ENTRY(1,agenda_rpw.cod_trans_mp,CHR(10)) = "no":U  THEN tt-param.tp-estado-nova = NO.
        IF ENTRY(2,agenda_rpw.cod_trans_mp,CHR(10)) = "yes":U THEN tt-param.tp-estado-erro = YES.
        IF ENTRY(2,agenda_rpw.cod_trans_mp,CHR(10)) = "no":U  THEN tt-param.tp-estado-erro = NO.
    END.

    for each tt_ped_exec_param:
        delete tt_ped_exec_param.
    end.

    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq = 1.
    raw-transfer tt-param to tt_ped_exec_param.tta_raw_param_ped_exec.

    for each tt_ped_exec_param_aux:
        delete tt_ped_exec_param_aux.
    end.

    create tt_ped_exec_param_aux.
    for each tt_ped_exec_sel:
        delete tt_ped_exec_sel.
    end.
    create tt_ped_exec_sel.

End Procedure.
