/******************************************************************************
**  ap0586.i - Include para calcular o numero de dias em atraso.
******************************************************************************/

def var da-inicial as date no-undo.
def var i-semana   as int  no-undo.
assign da-inicial = {1}.

find calen-coml
     where calen-coml.ep-codigo   = tit-ap.ep-codigo
       and calen-coml.cod-estabel = tit-ap.cod-estabel
       and calen-coml.data        = {1}
     no-lock no-error.
if  avail calen-coml then do:
    assign i-semana   = weekday({1}).
    if  calen-coml.tipo-dia <> 1 then do:
        if  (i-semana = 7 and emitente.ven-sabado = 1)
        or  (i-semana = 1 and emitente.ven-domingo = 1)
        or  (i-semana > 1 and i-semana < 7
        and emitente.ven-feriado = 1) then repeat:
            assign da-inicial = da-inicial + 1.
            find calen-coml
                 where calen-coml.ep-codigo   = tit-ap.ep-codigo
                   and calen-coml.cod-estabel = tit-ap.cod-estabel
                   and calen-coml.data        = da-inicial
                  no-lock no-error.
            if  not avail calen-coml then do:               
                run utp/ut-msgs.p(input "msg",
                                  input 648,
                                  input string(da-inicial)).
                disp tit-ap.cod-estabel
                     tit-ap.cod-esp
                     tit-ap.serie
                     tit-ap.nr-docto
                     tit-ap.parcela
                     tit-ap.dt-emissao
                     tit-ap.dt-vencimen
                     tit-ap.dt-desconto
                     de-desconto
                     de-vl-baixa
                     return-value @ c-mensagem
                with frame f-detalhe.
                down with frame f-detalhe.
            end.
            if  calen-coml.tipo = 1 then
                leave.
        end.

        if  (i-semana = 7 and emitente.ven-sabado = 2)
        or  (i-semana = 1 and emitente.ven-domingo = 2)
        or  (i-semana > 1 and i-semana < 7
        and emitente.ven-feriado = 2) then repeat:
            assign da-inicial = da-inicial - 1.
            find calen-coml
                 where calen-coml.ep-codigo  = tit-ap.ep-codigo
                 and  calen-coml.cod-estabel = tit-ap.cod-estabel
                 and  calen-coml.data        = da-inicial
                 no-lock no-error.
            if  not avail calen-coml then do:
                run utp/ut-msgs.p(input "show",
                                  input 648,
                                  input string(da-inicial)).
                disp tit-ap.cod-estabel
                     tit-ap.cod-esp
                     tit-ap.serie
                     tit-ap.nr-docto
                     tit-ap.parcela
                     tit-ap.dt-emissao
                     tit-ap.dt-vencimen
                     tit-ap.dt-desconto
                     de-desconto
                     de-vl-baixa
                     return-value @ c-mensagem
                with frame f-detalhe.
                down with frame f-detalhe.
                leave.
            end.
            if  calen-coml.tipo-dia = 1 then
                leave.
        end.
    end.
end.
if  da-inicial < {2} then
    assign {3} = {2} - da-inicial.
else 
    assign {3} = 0.


/* Fim */
