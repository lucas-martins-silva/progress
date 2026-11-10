/******************************************************************************
**
**   APP/AP0513.I3
**   Objetivo: Gera‡Æo do arquivo para exporta‡Æo.
**
******************************************************************************/
if  search("exp/exap01.p") = ? then do:

    output stream s-exporta to value(tt-param.arq-export) paged page-size 0.

    assign de-vl-debito    = 0
           de-vl-deb-fasb  = 0
           de-vl-deb-cmi   = 0
           de-vl-deb-pres  = 0
           de-vl-credito   = 0
           de-vl-cred-fasb = 0
           de-vl-cred-cmi  = 0
           de-vl-cred-pres = 0.

    data-block:
    do  da-data = tt-param.dt-transac-ini to tt-param.dt-transac-fim
        on error  undo data-block, return error
        on endkey undo data-block, return error
        on stop   undo data-block, return error:

        assign l-primeiro = yes.
        for each diario-ap no-lock
            where diario-ap.ep-codigo     = tt-param.i-ep-codigo
            and   diario-ap.dt-transacao  = da-data
            and   diario-ap.cod-estabel  >= tt-param.estab-ini
            and   diario-ap.cod-estabel  <= tt-param.estab-fim
            and   diario-ap.cod-esp      >= tt-param.espec-ini
            and   diario-ap.cod-esp      <= tt-param.espec-fim
            break by diario-ap.ep-codigo
                  by diario-ap.dt-transacao
                  by diario-ap.ct-conta
                  by diario-ap.sc-conta:

            if  l-primeiro = yes then do:
                assign l-primeiro = no.
                put stream s-exporta
                    "L"            at 01
                    "00000"        at 02
                    day(da-data)         format "99"       at 07
                    month(da-data)       format "99"       at 09
                    year(da-data)        format "9999"     at 11
                    day(da-data)         format "99"       at 15
                    month(da-data)       format "99"       at 17
                    year(da-data)        format "9999"     at 19
                    tt-param.i-ep-codigo format "999"      at 73
                    fill(" ",135)        format "x(135)"   at 76 skip.
            end.

            if  diario-ap.lancamento = 1 then
                assign de-vl-debito   = de-vl-debito + diario-ap.vl-debito
                       de-vl-deb-fasb = de-vl-deb-fasb + diario-ap.vl-deb-fasb
                       de-vl-deb-cmi  = de-vl-deb-cmi  + diario-ap.vl-deb-cmi
                       de-vl-deb-pres = de-vl-deb-pres + diario-ap.vl-deb-pres.
            else
                assign de-vl-credito   = de-vl-credito   + diario-ap.vl-credito
                       de-vl-cred-fasb = de-vl-cred-fasb + diario-ap.vl-cred-fasb
                       de-vl-cred-cmi  = de-vl-cred-cmi  + diario-ap.vl-cred-cmi
                       de-vl-cred-pres = de-vl-cred-pres + diario-ap.vl-cred-pres.

            if  last-of(diario-ap.ct-conta) or last-of(diario-ap.sc-conta) then do:
                if  de-vl-debito  > 0 or de-vl-deb-fasb > 0
                or  de-vl-deb-cmi > 0 or de-vl-deb-pres > 0 then do:
                    put stream s-exporta
                        "E     "                     at 01
                        "1"                          at 07
                        diario-ap.conta-contabil     at 08                        
                        "00"                         at 36
                        (de-vl-debito * 100) format "999999999999999" at 38
                        c-historico   format "x(40)"                  at 53.

                    if  avail param-fasb
                    and param-fasb.moeda-fasb > 0 then
                        put stream s-exporta
                        (de-vl-deb-fasb * 1000) format "999999999999" at 93.
                    else
                        put stream s-exporta "000000000000" at 104.

                    if  avail param-fasb
                    and param-fasb.moeda-cmi > 0 then
                        put stream s-exporta
                        (de-vl-deb-cmi * 1000)  format "999999999999" at 110
                        (de-vl-deb-pres * 1000) format "999999999999" at 127.
                    else
                        put stream s-exporta "000000000000" at 116
                                             "000000000000" at 128.

                    put stream s-exporta fill(" ",17) format "x(17)" at 140.
                    put stream s-exporta 
                        "AP"                         at 161
                        day(da-data)   format "99"   at 163
                        month(da-data) format "99"   at 165
                        year(da-data)  format "9999" at 167 skip.
                end.

                if  de-vl-credito  > 0 or de-vl-cred-fasb > 0
                or  de-vl-cred-cmi > 0 or de-vl-cred-pres > 0 then do:
                    put stream s-exporta
                        "E     "                     at 01
                        "2"                          at 07
                        diario-ap.conta-contabil     at 08                        
                        "00"                         at 36
                        (de-vl-credito * 100) format "999999999999999" at 38
                        c-historico   format "x(40)"                   at 53.

                    if  avail param-fasb
                    and param-fasb.moeda-fasb > 0 then
                        put stream s-exporta
                        (de-vl-cred-fasb * 1000) format "999999999999" at 93.
                    else
                        put stream s-exporta "000000000000" at 104.

                    if  avail param-fasb
                    and param-fasb.moeda-cmi > 0 then
                        put stream s-exporta
                        (de-vl-cred-cmi * 1000)  format "999999999999" at 110
                        (de-vl-cred-pres * 1000) format "999999999999" at 127.
                    else
                        put stream s-exporta "000000000000" at 116
                                             "000000000000" at 128.

                    put stream s-exporta fill(" ",17) format "x(17)" at 140.
                    put stream s-exporta
                        "AP"                         at 161
                        day(da-data)   format "99"   at 163
                        month(da-data) format "99"   at 165
                        year(da-data)  format "9999" at 167 skip.
                end.

                assign de-vl-debito    = 0
                       de-vl-deb-fasb  = 0
                       de-vl-deb-cmi   = 0
                       de-vl-deb-pres  = 0
                       de-vl-credito   = 0
                       de-vl-cred-fasb = 0
                       de-vl-cred-cmi  = 0
                       de-vl-cred-pres = 0.
            end.
            assign i-cont = i-cont + 1.
        end.

/*        if  l-primeiro = no then
 *             run pi-acompanhar in h-acomp (input (c-liter-1 + string(i-cont) + c-liter-2)).*/
    end.

    output stream s-exporta close.
end.
else do:
    run exp/exap01.p.
end.

assign i-emp-s = 0.

/* Fim */
