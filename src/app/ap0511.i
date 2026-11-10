/****************************************************************************
**
**   AP0511.I - Copia de Cheques
**   
**   Esta include ‚ utilizada no ap0511 e no ap0523.
**   Ao alterar esta include estes dois programas dever ser testados.
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

if  line-counter(s-copia) > 63 then
    page stream s-copia.

if  avail talonario then do:
    if  l-imp-form = yes and tt-param.reemissao = no
    and talonario.automatico = yes then do:
        assign c-historico = "Teste Formulario Cheque"
               da-data     = today.
    
        if  talonario.prox-copia = 0 then do:
            assign talonario.prox-copia = 1.
            /************ MultiPlanta *************/
            run pi-cria-tt-dados-talonario (input 2).
            /**************************************/
        end.
        
        do  i-cont-for = 1 to i-formulario:
            if  tt-param.imp-hist = no
                then put stream s-copia skip(20).
                else put stream s-copia skip( 2).
            disp stream s-copia
                 empresa.razao-social
                 empresa.cidade
                 da-data
                 talonario.prox-copia when avail talonario @ c-nr-copia
                 che-emit.nr-cheque
                 portador.nome
                 c-historico with frame f-teste.
            down stream s-copia with frame f-teste.
            page stream s-copia.
    
            assign i-nr-copia = integer(talonario.prox-copia) no-error.
            if  error-status:error = no then do:
                assign talonario.prox-copia = i-nr-copia + 1.
                /************ MultiPlanta *************/
                run pi-cria-tt-dados-talonario (input 2).
                /**************************************/
            end.
        end.
        assign da-data = che-emit.dt-emissao.
    end.
end.

if  tt-param.quant = 1 then do:
    if  tt-param.imp-hist = no
        then put stream s-copia skip(20).
        else put stream s-copia skip( 2).
    disp stream s-copia
         empresa.razao-social
         empresa.cidade
         da-data
         talonario.prox-copia when avail talonario @ c-nr-copia
         de-valor @ che-emit.valor-docto
         che-emit.nr-cheque
         che-emit.literal
         c-conta
         portador.nome with frame f-copia.
    if  tt-param.imp-hist = yes then do:
        put stream s-copia "REFERENTE  A  :  " skip.
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
                    put stream s-copia b-mov-ap.historico skip.
            end.
            else if  mov-ap.historico <> " " then
                     put stream s-copia mov-ap.historico skip.
        end.
    end.

    put stream s-copia
        "--------------------------------------------------"
        "------------------------------" at 51.
    down stream s-copia with frame f-copia.
    page stream s-copia.
end.
else do:
    disp stream s-copia
        empresa.razao-social
        empresa.cidade
        da-data
        talonario.prox-copia when avail talonario @ c-nr-copia
        de-valor @ che-emit.valor-docto
        che-emit.nr-cheque
        che-emit.literal
        c-conta
        portador.nome with frame f-copia.

    if  tt-param.imp-hist = yes then do:
        put stream s-copia "REFERENTE  A  :  " skip.
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
                    put stream s-copia b-mov-ap.historico skip.
            end.
            else if  mov-ap.historico <> " " then
                     put stream s-copia mov-ap.historico skip.
        end.
    end.

    put stream s-copia
        "--------------------------------------------------"
        "------------------------------" at 51.
    down stream s-copia with frame f-copia.
    if  tt-param.quant = 2 then
        put stream s-copia skip(13).
    else
        put stream s-copia skip(3).
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

if  l-imp-form = yes then
    assign l-imp-form = no.
    
/* AP0511.I */
