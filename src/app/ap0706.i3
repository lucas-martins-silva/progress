/*******************************************************************************
**
**  Include.: AP0706.I3
**  Objetivo: C lculo do Prazo M dio de Compras, Atraso M dio de Pagamento e
**            Perfil de Distribui‡Æo de Compras
**
*******************************************************************************/

page.

{utp/ut-liter.i Vencimento_em_Dias * R}
assign c-text-1 = trim(return-value).
{utp/ut-liter.i Valor_das_Compras * L}
assign c-text-2 = trim(return-value)
       c-text-2 = fill(" ", 21 - length(c-text-2)) + c-text-2.
{utp/ut-liter.i Sub_Total * L}
assign c-text-4 = trim(return-value)
       c-text-4 = fill(" ", 18 - length(c-text-4)) + c-text-4.
{utp/ut-liter.i Perc * L}
assign c-text-3 = trim(return-value)
       c-text-5 = trim(return-value).

{utp/ut-liter.i Perfil_de_Distribui‡Æo_de_Compras * C}
put skip(03)
    ("** ":U + trim(return-value) + " **":U) format "x(50)":U at 42
    skip(2)
    c-text-1 at 20 space(05)
    c-text-2 space(05)
    c-text-3 space(05)
    c-text-4 space(05)
    c-text-5 skip
    fill("-":U, 22) format "x(22)":U at 20 space(05)
    fill("-":U, 21) format "x(21)":U space(05)
    fill("-":U, 06) format "x(06)":U space(05)
    fill("-":U, 18) format "x(18)":U space(05)
    fill("-":U, 06) format "x(06)":U skip.

do  i-cont = 1 to 14:
    assign de-percent[i-cont] = if  de-vencimen[14] <> 0 then
                                    de-vencimen[i-cont] * 100 / de-vencimen[14]
                                else 0.
    if  i-cont < 14 then do:
        assign de-percent[14] = de-percent[14] + de-percent[i-cont]
               de-perc-acum[i-cont] = if  i-cont > 1 then
                                           de-perc-acum[i-cont - 1] + de-percent[i-cont]
                                      else de-percent[i-cont]
               de-venc-acum[i-cont] = if  i-cont > 1 then
                                           de-venc-acum[i-cont - 1] + de-vencimen[i-cont]
                                      else de-vencimen[i-cont].
    end.

    case i-cont:
        when (1) then do:
            {utp/ut-liter.i At‚ * L}
            assign c-vencto = trim(return-value) + " 15":U.
        end.

        when (13) then do:
            {utp/ut-liter.i Mais_de * L}
            assign c-vencto = trim(return-value) + " 180":U.
        end.

        when (14) then do:
            {utp/ut-liter.i Total * L}
            assign c-vencto = trim(return-value).
        end.

        otherwise do:
            {utp/ut-liter.i De * L}
            assign c-vencto = trim(return-value) + " "
                            + string((((i-cont - 1) * 15) + 1),">>9":U).
            {utp/ut-liter.i at‚ * L}
            assign c-vencto = c-vencto + " " + trim(return-value) + " "
                            + string((i-cont * 15),">>9":U).
        end.
    end case.

    disp c-vencto
         de-vencimen[i-cont] @ de-vencimen[1]
         de-percent[i-cont] @ de-percent[1]
         with frame f-perfil.

    if  i-cont < 14 then
        disp de-venc-acum[i-cont] @ de-venc-acum[1]
             de-perc-acum[i-cont] @ de-perc-acum[1]
             with frame f-perfil.

    down with frame f-perfil.
end.

assign i-prazo  = if  de-pr-geral <> 0 then de-pr-data / de-pr-geral else 0
       i-atraso = if  de-at-geral <> 0 then de-at-data / de-at-geral else 0.

display i-prazo
        i-atraso
        with frame f-pmc-amp.

/* AP0706.I3 */
