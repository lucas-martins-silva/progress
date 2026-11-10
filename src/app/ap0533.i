/****************************************************************************
**
**   AP0533.I - Copia de Cheques
**
***************************************************************************/

find cta-corrente
    where cta-corrente.cod-banco    = portador.cod-banco
    and   cta-corrente.agencia      = portador.agencia
    and   cta-corrente.conta-corren = portador.conta-corren
    no-lock no-error.
if  avail cta-corrente then do:
    assign c-conta = string(cta-corrente.conta-saldo, param-global.formato-conta-contabil).
end.

assign da-data = che-emit.dt-emissao.

create tt-copia.
assign tt-copia.razao-social = empresa.razao-social
       tt-copia.cidade       = empresa.cidade
       tt-copia.nr-copia     = if avail talonario then
                                  talonario.prox-copia 
                               else
                                  c-nr-copia  
       tt-copia.nr-cheque    = che-emit.nr-cheque
       tt-copia.nome-port    = portador.nome
       tt-copia.literal      = che-emit.literal
       tt-copia.valor        = de-valor
       tt-copia.data         = da-data
       tt-copia.conta        = c-conta.
       
if  tt-param.imp-hist = yes then do:
    for each mov-ap no-lock
        where mov-ap.ep-codigo = che-emit.ep-codigo
        and   mov-ap.portador  = che-emit.portador
        and   mov-ap.nr-cheque = che-emit.nr-cheque:

        if  mov-ap.transacao = 2 then do:
            find first b-mov-ap
            where b-mov-ap.ep-codigo = mov-ap.ep-codigo
            and   b-mov-ap.cod-forn  = mov-ap.cod-forn
            and   b-mov-ap.cod-estab = mov-ap.cod-estab
            and   b-mov-ap.serie     = mov-ap.serie
            and   b-mov-ap.cod-esp   = mov-ap.cod-esp
            and   b-mov-ap.nr-docto  = mov-ap.nr-docto
            and   b-mov-ap.parcela   = mov-ap.parcela
            and   b-mov-ap.transacao = 1
            and   b-mov-ap.historico <> " "
                  no-lock no-error.
            if  avail b-mov-ap then
                assign tt-copia.historico = b-mov-ap.historico.
        end.
            else if  mov-ap.historico <> " " then
                assign tt-copia.historico = mov-ap.historico.
    end.
end.

if  avail talonario then do:
    assign i-nr-copia = integer(talonario.prox-copia) no-error.
    if  error-status:error = no then do:
        assign talonario.prox-copia = i-nr-copia + 1.
        /************ MultiPlanta *************/
        run pi-cria-tt-dados-talonario (input 2).
        /**************************************/
    end.
end.

/* AP0533.I */
