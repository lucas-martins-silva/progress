/*******************************************************************************
***
*** app/ap0740rp.i3 - Defini‡Æo Literais.
***
*******************************************************************************/

{utp/ut-liter.i Fornecedor:}
assign c-fornecedor = trim(return-value).

{utp/ut-liter.i Conta_Cont bil:}
assign c-conta = trim(return-value).

{utp/ut-field.i mgadm tit-ap matriz 1}
assign c-matriz = trim(return-value).

{utp/ut-field.i mgadm tit-ap moeda 1}
assign c-moeda = trim(return-value).

{utp/ut-field.i mgadm tit-ap cod-esp 1}
assign c-especie = trim(return-value).

{utp/ut-field.i mgadm tit-ap nome-abrev 1}
assign c-nome-abrev = trim(return-value).

{utp/ut-liter.i RazÆo_Social}
assign c-razao-social = trim(return-value).

{utp/ut-liter.i Total_Fornecedor:}
assign c-total-fornec = trim(return-value).

{utp/ut-liter.i Total_Conta:}
assign c-total-conta = trim(return-value).

{utp/ut-liter.i Total_Tipo_Pagamento:}
assign c-total-tp-pagto = trim(return-value).

{utp/ut-liter.i Total_Matriz:}
assign c-total-matriz = trim(return-value).

{utp/ut-liter.i Total_Esp‚cie:}
assign c-total-especie = trim(return-value).

{utp/ut-liter.i Total_do_Mˆs:}
assign c-total-mes = trim(return-value).

{utp/ut-liter.i Total_Normal:}
assign c-total-normal = trim(return-value).

{utp/ut-liter.i Total_PrevisÆo:}
assign c-total-prev = trim(return-value).

{utp/ut-liter.i Total_Atencipa‡Æo:}
assign c-total-antec = trim(return-value).

{utp/ut-liter.i Total_Geral:}
assign c-total-geral = trim(return-value).

{utp/ut-liter.i Tipo_Pagamento}
assign c-tipo-pagto = trim(return-value).

{utp/ut-liter.i Hist¢rico:}
assign c-historico = trim(return-value).

{utp/ut-liter.i Resumo_dos_Compromissos_Vencidos} 
assign c-resumo1 = trim(return-value).   

{utp/ut-liter.i Resumo_dos_Compromissos_…_Vencer} 
assign c-resumo2 = trim(return-value).   

{utp/ut-liter.i Registros:}
assign c-acomp = trim(return-value).

{utp/ut-liter.i Grupo}
assign c-grupo = trim(return-value).

{utp/ut-liter.i Total * C}
assign c-total  = trim(return-value) + ":":U. 

{utp/ut-liter.i Vencidas____at‚ * C}
assign c-vencidas = trim(return-value).

{utp/ut-liter.i __Dias * C}
assign c-dias = trim(return-value) + ":":U.

{utp/ut-liter.i _______de * C}
assign c-de = trim(return-value).

{utp/ut-liter.i ___a_ * C}
assign c-a = trim(return-value).

{utp/ut-liter.i _______Mais__de * C}
assign c-mais = trim(return-value).

{utp/ut-liter.i ·_Vencer___at‚ * C}
assign c-vencer = trim(return-value).   

{utp/ut-liter.i Total_Original}
assign c-original = trim(return-value).

{utp/ut-liter.i Total_Saldo}
assign c-saldo = trim(return-value).

{utp/ut-liter.i Total_Normal}
assign c-normal = trim(return-value).

{utp/ut-liter.i Total_PrevisÆo}
assign c-previsao = trim(return-value).

{utp/ut-liter.i Total_Antecipa‡Æo}
assign c-antecipacao = trim(return-value).

{utp/ut-liter.i Total_ProvisÆo:}
assign c-total-prov = trim(return-value).

{utp/ut-liter.i Total_ProvisÆo}
assign c-provisao = trim(return-value).

/* -------------------------------------- Vencidos ----------------------------------------- */
assign c-30-ven   = c-vencidas  + "  " + string(tt-param.i-venc-31 - 1,">9")  + "  " + c-dias  
       c-60-ven   = "       " + c-de + "  " + string(tt-param.i-venc-31,">9")
                    + "  " + c-a  + " " + string(tt-param.i-venc-60,">9")  + "  " + c-dias 
       c-90-ven   = "       " + c-de   + " " + string(tt-param.i-venc-61,">9")
                    + "  " + c-a  + " " + string(tt-param.i-venc-90,">>9") + "  " + c-dias 
       c-91-ven   = "      " + c-mais + "  " + string(tt-param.i-venc-90 + 1,">>9") + "  " + c-dias. 

/* -------------------------------------- A Vencer ------------------------------------------ */
assign c-30-aven  = c-vencer + "   " + string(tt-param.i-a-venc-31 - 1,">9") + "  " + c-dias 
       c-60-aven  = "     " + c-de   + "  " + string(tt-param.i-a-venc-31,">9")
                    + "  " + c-a  + "   " + string(tt-param.i-a-venc-60,">9") + "  " + c-dias 
       c-90-aven  = "     " + c-de   + "  " + string(tt-param.i-a-venc-61,">9")
                    + "  " + c-a  + "   " + string(tt-param.i-a-venc-90,">9") + "  " + c-dias 
       c-120-aven = "     " + c-de   + "  " + string(tt-param.i-a-venc-91,">9")
                    + "  " + c-a  + "  " + string(tt-param.i-a-venc-120,">>9") + "  " + c-dias 
       c-121-aven = "    " + c-mais + "    " + string(tt-param.i-a-venc-120 + 1,">>9") + "  " + c-dias. 

/* Fim de Include */

