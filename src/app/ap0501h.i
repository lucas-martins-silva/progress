/******************************************************************************
**
**  Programa : ap0501h.i
**  Objetivo.: Verifica se o Fornecedor Possui Antecipa‡Æo.
**
******************************************************************************/

/*--- Verifica se o Fornecedor possui Antecipa‡Æo ---*/
find first tit-ap use-index codigo no-lock
     where tit-ap.ep-codigo    = lin-i-ap.ep-codigo
     and   tit-ap.cod-fornec   = lin-i-ap.cod-fornec
     and   tit-ap.tipo         = 2
     and   tit-ap.vl-saldo     > 0
     {1}
     no-error.   
if  not avail tit-ap then do:

    /*--- Verifica se a matriz possui antecipa‡Æo ---*/
    find first emitente
         where emitente.cod-emitente = lin-i-ap.cod-fornec
         and   emitente.identific   <> 1 no-lock no-error.

    if  avail emitente then do:   
        find first b-emitente
             where b-emitente.nome-abrev   = emitente.nome-matriz
             and   b-emitente.identific   <> 1 no-lock no-error.


        if  avail b-emitente then do:

            {utp/ut-liter.i Matriz map C}
            assign c-fornecedor = trim(return-value).

            find first tit-ap use-index matriz no-lock
                 where tit-ap.ep-codigo    = lin-i-ap.ep-codigo
                   and tit-ap.matriz       = b-emitente.cod-emitente
                   and tit-ap.tipo         = 2
                   and tit-ap.vl-saldo     > 0
                   {1}
                 no-error.   

            if  avail tit-ap then do:
                assign l-antecipacao = yes.
            end.
        end.
    end.
end.
else do:
    {utp/ut-liter.i Fornecedor map C}
    assign c-fornecedor  = trim(return-value)
           l-antecipacao = yes.
end.

if  l-antecipacao = yes then do:

    run utp/ut-msgs.p (input "show",
                       input {2},
                       input trim(c-fornecedor)).

    if  return-value = 'yes' then do:

        if  l-provisao then do:
            run app/ap0555.w (input yes,
                              input rowid(lin-i-ap),
                              2).
        end.
        else do:
            run app/ap0555.w (input yes,
                              input rowid(lin-i-ap)).
        end.
    end.
end.

/* Fim de Include */
