/*******************************************************************************
**
**  Include.: AP0708.I
**  Objetivo: Complemento EmissÆo de Notas de Simples Remessa
**
*******************************************************************************/

find emitente
    where emitente.cod-emitente = che-emit.cod-fornec
    and   emitente.identific <> 1 no-lock no-error.

if  first-of(che-emit.cod-fornec) or first-of(che-emit.literal) then do:
    assign de-tot-orig = 0
           de-tot-desc = 0.
    if  emitente.bairro <> " " then
        put skip(3)
            emitente.nome-emit    at 10
            emitente.endereco     at 10
            c-data                at 53
            emitente.bairro       at 10
            emitente.cod-emitente at 53.
    else
        put skip(4)
            emitente.nome-emit    at 10
            c-data                at 53
            emitente.endereco     at 10
            emitente.cod-emitente at 53.

    put emitente.cidade at 10
        emitente.cep    at 10
        skip(1).

    if  tt-param.l-copia = yes then do:
        if  emitente.bairro <> " " then
            put stream s-copia
                skip(3)
                emitente.nome-emit    at 10
                emitente.endereco     at 10
                c-data                at 53
                emitente.bairro       at 10
                emitente.cod-emitente at 53.
        else
            put stream s-copia
                skip(4)
                emitente.nome-emit    at 10
                c-data                at 53
                emitente.endereco     at 10
                emitente.cod-emitente at 53.

        put stream s-copia
            emitente.cidade at 10
            emitente.cep    at 10
            skip(1).
    end.
end.

/* Cabe‡alho do Documento (Implanta‡Æo do T¡tulo) */
if  tt-param.tipo = 2
and (avail espec-ap and espec-ap.tipo = 1) then do:
    find first b-mov-ap
         where b-mov-ap.ep-codigo   = mov-ap.ep-codigo
           and b-mov-ap.cod-fornec  = mov-ap.cod-fornec
           and b-mov-ap.cod-estabel = mov-ap.cod-estabel
           and b-mov-ap.cod-esp     = mov-ap.cod-esp
           and b-mov-ap.serie       = mov-ap.serie
           and b-mov-ap.nr-docto    = mov-ap.nr-docto
           and b-mov-ap.parcela     = mov-ap.parcela
           and b-mov-ap.transacao   = 1 no-lock no-error.
    if  avail b-mov-ap then do:
        {utp/ut-liter.i Nota_Fiscal * L}
        put b-mov-ap.nr-docto  at 01 format "x(16)"
            b-mov-ap.valor-mov at 18 format ">>>>>>9.99-"
            trim(return-value) at 40 format "x(15)".

        if  tt-param.l-copia = yes then
            put stream s-copia
                b-mov-ap.nr-docto  at 01 format "x(16)"
                b-mov-ap.valor-mov at 18 format ">>>>>>9.99-"
                trim(return-value) at 40 format "x(15)".
    end.

    /* Antecipa‡äes e Notas de Cr‚dito/D‚bito */
    for each b-mov-ap no-lock
       where b-mov-ap.ep-codigo   = mov-ap.ep-codigo
         and b-mov-ap.cod-fornec  = mov-ap.cod-fornec
         and b-mov-ap.cod-estabel = mov-ap.cod-estabel
         and b-mov-ap.cod-esp     = mov-ap.cod-esp
         and b-mov-ap.serie       = mov-ap.serie
         and b-mov-ap.nr-docto    = mov-ap.nr-docto
         and b-mov-ap.parcela     = mov-ap.parcela
         and b-mov-ap.esp-ant     > " ":

        {utp/ut-liter.i Antecipa‡Æo * L}
        put b-mov-ap.docto-ant     at 01 format "x(16)"
            (- b-mov-ap.valor-mov) at 18 format ">>>>>>9.99-"
            trim(return-value)     at 40 format "x(15)".

        if  tt-param.l-copia = yes then
            put stream s-copia
                b-mov-ap.docto-ant     at 01 format "x(16)"
                (- b-mov-ap.valor-mov) at 18 format ">>>>>>9.99-"
                trim(return-value)     at 40 format "x(15)".
    end.

    /* Os campos de antecipa‡Æo sao usados para ligar
       as notas de Cr‚dito e D‚bito a Invoice */
    for each b-mov-ap no-lock
       where b-mov-ap.ep-codigo   = mov-ap.ep-codigo
         and b-mov-ap.cod-estabel = mov-ap.cod-estabel
         and b-mov-ap.esp-ant     = mov-ap.cod-esp
         and b-mov-ap.serie-ant   = mov-ap.serie
         and b-mov-ap.docto-ant   = mov-ap.nr-docto
         and b-mov-ap.parc-ant    = mov-ap.parcela
         and b-mov-ap.cod-fornec  = mov-ap.cod-fornec
         and b-mov-ap.transacao   = 16:

        find b-espec-ap
            where b-espec-ap.cod-esp = b-mov-ap.cod-esp
            no-lock no-error.
        if  avail b-espec-ap then do:
            assign de-original = if b-espec-ap.tipo = 5 then - 1 else 1
                   de-original = de-original * b-mov-ap.valor-mov
                   c-especie   = {adinc/i01ad104.i 04 b-espec-ap.tipo}.

            put b-mov-ap.nr-docto format "x(16)"       at 01
                de-original       format ">>>>>>9.99-" at 18
                c-especie                              at 40.

            if  tt-param.l-copia = yes then
                put stream s-copia
                    b-mov-ap.nr-docto format "x(16)"       at 01
                    de-original       format ">>>>>>9.99-" at 18
                    c-especie                              at 40.
        end.
    end.
end.

{utp/ut-liter.i Pagamento * L}
assign de-vl-liq   = mov-ap.valor-mov - mov-ap.vl-desconto
       de-original = mov-ap.valor-mov.

put mov-ap.nr-docto    at 01 format "x(16)"
    de-original        at 18 format ">>>>>>9.99-"
    mov-ap.vl-desconto at 30 format ">>>>>9.99"
    trim(return-value) at 40 format "x(15)"
    de-vl-liq          at 56 format ">>>>>>9.99-".

if  tt-param.l-copia = yes then
    put stream s-copia
        mov-ap.nr-docto    at 01 format "x(16)"
        de-original        at 18 format ">>>>>>9.99-"
        mov-ap.vl-desconto at 30 format ">>>>>9.99"
        trim(return-value) at 40 format "x(15)"
        de-vl-liq          at 56 format ">>>>>>9.99-".

assign de-tot-orig = de-tot-orig + de-vl-liq
       de-tot-desc = de-tot-desc + mov-ap.vl-desconto.

if  last-of(che-emit.cod-fornec) or last-of(che-emit.literal) then do:
    put skip(1)
        (de-tot-desc + de-tot-orig) at 18 format ">>>>>>9.99-"
        de-tot-desc at 30 format ">>>>>9.99"
        de-tot-orig at 56 format ">>>>>>9.99-".
    page.

    if  tt-param.l-copia = yes then do:
        put stream s-copia skip(1)
            (de-tot-desc + de-tot-orig) at 18 format ">>>>>>9.99-"
            de-tot-desc at 30 format ">>>>>9.99"
            de-tot-orig at 56 format ">>>>>>9.99-".
        page stream s-copia.
    end.
end.

/* AP0599.I */
