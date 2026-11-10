/***************************************************************************
**
** ap1001p.i3 - Include usada na ap1001p.i2.
**
***************************************************************************/

assign l-avisa         = no
       i-num-reg       = i-num-reg + 1
       c-carteira      = tt-digita.ita-carteira
       l-aceite        = tt-digita.ita-aceite
       c-uso-banco-ita = tt-digita.ita-uso-banco.

find first emitente
     where emitente.cod-emitente = {4} no-lock no-error.
if avail emitente then do:
    if emitente.natureza = 1 then do:   /* Pessoa F°sica */
        assign i-natureza = 01.
    end.
    else do:
        if emitente.natureza = 2 then do:   /* Pessoa Jur°dica */
            assign i-natureza = 02.
        end.
        else do: 
            assign i-natureza = 00.
        end.
    end.
end.

/*--- CRêDITO EM CONTA CORRENTE ---*/
if tt-param.i-tipo-pag = 1
or tt-param.i-tipo-pag = 2 
or tt-param.i-tipo-pag = 5 then do:

    assign c-dv-agcc      = substr(c-cc-forn,10,2)
           i-lote         = 1
           c-linha-check1 = "0409" + substr(c-agencia,3,4) + substr(c-cc-forn,1,10)
           de-calc-check  = dec(c-linha-check1)
           c-linha-check2 = string((de-calc-check + de-valor-pag) * 5).

    if  length(c-linha-check2) > 18 then
        assign c-linha-check2 = substr(c-linha-check2, length(c-linha-check2) - 17, 18).

    put stream relat
        "2"                                                           at 001
        substr(cta-corrente.agencia-extrato,3,4)        format "9999" at 002
        fn-preenche-campo(cta-corrente.conta-corren-ext,7) 
                                                     format "9999999" at 006
        "0409"                                                        at 033.

    if  c-agencia <> "" then
        put stream relat  
            substr(c-agencia,3,4)                       format "9999" at 037.

    if  c-cc-forn <> "" then
        put stream relat 
            substr(fn-preenche-campo(c-cc-forn,11),1,10)
                                                format "9999999999"   at 041.

    put stream relat
        "4"                                                           at 051
        "0"                                                           at 052.

    if tt-param.i-tipo-pag = 1 
    or tt-param.i-tipo-pag = 2 then
        put stream relat
            "5"                                                       at 053.
    else
        put stream relat
            "7"                                                       at 053.

    if tt-param.i-tipo-pag = 2 then
       put stream relat
           "8"                                                           at 054.
    else 
       put stream relat
           "2"                                                           at 054.

    put stream relat
        de-valor-pag                           format "9999999999999" at 055
/*        string({5})                          format "999999999999999" at 068*/
        day(today)                                        format "99" at 083
        month(today)                                      format "99" at 085
        substr(string(year(today),"9999"),3,2)            format "99" at 087.

    if  {1} < today then
        put stream relat
        day(tt-param.da-pagto)                             format "99" at 089
        month(tt-param.da-pagto)                           format "99" at 091
        substr(string(year(tt-param.da-pagto),"9999"),3,2) format "99" at 093.
    else
        put stream relat
        day({1})                                          format "99" at 089
        month({1})                                        format "99" at 091
        substr(string(year({1}),"9999"),3,2)              format "99" at 093.

    put stream relat
        c-nome                                         format "x(30)" at 095
        string({5})                          format "999999999999999" at 220
        "14"                                                          at 235
        dec({2})                                format "99999999999"  at 248
        i-tipo-mov                                        format "99" at 259
        c-linha-check2                                                at 263
        i-natureza                                        format "99" at 281
        de-inscric                            format "99999999999999" at 283.

    if tt-param.i-tipo-pag <> 2 then
       put stream relat
          "00000"                                                       at 307
          substr(fn-preenche-campo(c-cc-forn,11),11,1)       format "9" at 314.

    put stream relat
        i-num-reg                                     format "999999" at 315.

end.

/*--- DOC ---*/
if tt-param.i-tipo-pag = 3
or tt-param.i-tipo-pag = 7
or tt-param.i-tipo-pag = 8 then do:

    /* Se a conta corrente do fornecedor possuir dois digitos ent∆o o primeiro 
       digito dever† ser informado juntamente com a conta corrente, na posiá∆o
       314 ser† informado o segundo digito */

    if  length(c-cc-forn) = 12 then
        assign c-dig-conta = substring(c-cc-forn, 12,01)
               c-cc-forn   = substring(c-cc-forn, 02,09) 
                           + substring(c-cc-forn, 11,01).
    else
        assign c-dig-conta = substring(c-cc-forn, 11,01).

    assign c-linha-check1 = string(i-nr-banco,"9999") + string(dec(substr(c-agencia,3,4)), "9999")
                                                      + string(dec(substr(c-cc-forn,1,10)), "9999999999").

    if tt-param.i-tipo-pag = 3 then
       assign i-mult = 5.
    else 
       assign i-mult = tt-param.i-tipo-pag.

    assign de-calc-check  = dec(c-linha-check1)
           c-linha-check2 = string((de-calc-check + de-valor-pag) * i-mult)
           de-linha-check = 0.

    if  length(c-linha-check2) > 18 then
        assign c-linha-check2 = substr(c-linha-check2, length(c-linha-check2) - 17, 18).
    else 
        if length(c-linha-check2) < 18 then
           assign de-linha-check = dec(c-linha-check2).

    put stream relat
        "2"                                                           at 001
        substr(cta-corrente.agencia-extrato,3,4)        format "9999" at 002
        fn-preenche-campo(cta-corrente.conta-corren-ext,7) 
                                                     format "9999999" at 006
        i-nr-banco  format "9999"                                     at 033.

    if  c-agencia <> "" then
        put stream relat  substr(c-agencia,3,4) format "9999"         at 037.

    if  c-cc-forn <> "" then
        put stream relat 
                substr(c-cc-forn, 01,10)          format "9999999999" at 041.

    put stream relat
        "4"                                                           at 051
        "0"                                                           at 052.
    if tt-param.i-tipo-pag = 3 then
        put stream relat
            "5"                                                       at 053.
    else
        put stream relat
            tt-param.i-tipo-pag                            format "9" at 053.

    put stream relat
        "2"                                                           at 054
        de-valor-pag                           format "9999999999999" at 055
        day(today)                                        format "99" at 083
        month(today)                                      format "99" at 085
        substr(string(year(today),"9999"),3,2)            format "99" at 087.

    if  {1} < today then
        put stream relat
        day(tt-param.da-pagto)                             format "99" at 089
        month(tt-param.da-pagto)                           format "99" at 091
        substr(string(year(tt-param.da-pagto),"9999"),3,2) format "99" at 093.
    else
        put stream relat
        day({1})                                          format "99" at 089
        month({1})                                        format "99" at 091
        substr(string(year({1}),"9999"),3,2)              format "99" at 093.

    put stream relat 
        c-nome                                         format "x(30)" at 095.
        /*c-endereco                                     format "x(30)" at 125
 *         c-cidade                                       format "x(15)" at 155
 *         c-estado                                       format "x(02)" at 170
 *         dec(substr(string(i-cep,"99999999"),1,5))      format "99999" at 172.*/

        /* A impress∆o acima foi colocada em coment†rio pois conforme o layout do Unibanco
       quando o campo Emiss∆o de Aviso na posiá∆o 52 for igual a ZERO n∆o deve imprimir 
       os campos em coment†rio acima.
       Favor n∆o excluir os campos em coment†rio pois isto ainda est† em faze de testes.
       OBS.: O campo Emiss∆o de Aviso Ç fixo zero*/

    find first agencia
         where agencia.cod-banco = cta-corrente.cod-banco
         and   agencia.agencia   = cta-corrente.agencia no-lock no-error.

    if  avail agencia then
        put stream relat
            fn-free-accent(caps(agencia.nome))         format "x(20)" at 197.

    put stream relat
        "000"                                                         at 217
        string({5})                          format "999999999999999" at 220
        "14"                                                          at 235
        dec({2})                                 format "99999999999" at 248
        i-tipo-mov                                        format "99" at 259.

    if tt-param.i-tipo-pag = 7 then
        put stream relat 
                "0" at 261.
    else if tt-param.i-tipo-pag = 8 then
        put stream relat 
                "9" at 261.

        if de-linha-check > 0 then
           put stream relat 
               de-linha-check                                         at 263.
        else
           put stream relat
               c-linha-check2                                         at 263.

    put stream relat
        i-natureza                                        format "99" at 281
        de-inscric                            format "99999999999999" at 283
        "00000"                                                       at 307
        substr(c-agencia,7,1)                              format "9" at 313.

    put stream relat
        c-dig-conta                                        format "9" at 314.

    put stream relat
        i-num-reg                                     format "999999" at 315.
end.

/*--- COBRANÄA ESPECIAL ---*/
if  tt-param.i-tipo-pag = 10 then do:
    assign c-dv-agcc      = substr(c-cc-forn,10,2)
           i-lote         = 1
           c-linha-check1 = "0409" + substr(c-agencia,3,4) +
                                     substr(c-cc-forn,1,10)
           de-calc-check  = dec(c-linha-check1)
           c-linha-check2 = string((de-calc-check + de-valor-pag) * 5).

    if  length(c-linha-check2) > 18 then
        assign c-linha-check2 = substr(c-linha-check2, length(c-linha-check2) - 17, 18).

    put stream relat
        "2"                                                           at 001
        substr(cta-corrente.agencia-extrato,3,4)   format "9999"      at 002
        fn-preenche-campo(cta-corrente.conta-corren-ext,7) 
                                                     format "9999999" at 006
        "0409"                                                        at 033.

    if  c-agencia <> "" then
        put stream relat  substr(c-agencia,3,4) format "9999"         at 037.

    if  c-cc-forn <> "" then
        put stream relat 
            substr(fn-preenche-campo(c-cc-forn,11),1,10)
                                                  format "9999999999" at 041.

    put stream relat
        "4"                                                           at 051
        "0"                                                           at 052
        "5"                                                           at 053
        "0"                                                           at 054
        de-valor-pag                           format "9999999999999" at 055
/*        string({5})                          format "999999999999999" at 068*/
        day(today)                                        format "99" at 083
        month(today)                                      format "99" at 085
        substr(string(year(today),"9999"),3,2)            format "99" at 087.

    if  {1} < today then
        put stream relat
        day(tt-param.da-pagto)                             format "99" at 089
        month(tt-param.da-pagto)                           format "99" at 091
        substr(string(year(tt-param.da-pagto),"9999"),3,2) format "99" at 093.
    else
        put stream relat
        day({1})                                          format "99" at 089
        month({1})                                        format "99" at 091
        substr(string(year({1}),"9999"),3,2)              format "99" at 093.

    put stream relat
        c-nome                                         format "x(20)" at 095
        string({5})                          format "999999999999999" at 220
        "14"                                                          at 235
        
        /* falar com Edna sobre esta posicao */
        77445                                          format "99999" at 237
        day({1})                                          format "99" at 242
        month({1})                                        format "99" at 244
        substr(string(year({1}),"9999"),3,2)              format "99" at 246
        dec({2})                                 format "99999999999" at 248
        i-tipo-mov                                        format "99" at 259
        c-linha-check2                                                at 263
        tt-digita.titulo-banco               format "999999999999999" at 281
        substr(fn-preenche-campo(c-cc-forn,11),11,1)       format "9" at 314
        i-num-reg                                     format "999999" at 315.
end.

/*--- DOCUMENTOS DO UNIBANCO ---*/
if  tt-param.i-tipo-pag = 30 then do:
    put stream relat
        "1"                                                           at 001
        substr(cta-corrente.agencia-extrato,3,4)        format "9999" at 002
        fn-preenche-campo(cta-corrente.conta-corren-ext,7) 
                                                     format "9999999" at 006
        substr(cta-corrente.agencia-extrato,3,4)        format "9999" at 013
        fn-preenche-campo(cta-corrente.conta-corren-ext,7) 
                                                     format "9999999" at 017        
        substr(cta-corrente.agencia-extrato,3,4)        format "9999" at 024
        fn-preenche-campo(cta-corrente.conta-corren-ext,7) 
                                                     format "9999999" at 028
        "01"                                                          at 035
        string({5})                                    format "x(25)" at 044
        "14"                                                          at 069
        i-tipo-mov                                        format "99" at 071
        tt-digita.titulo-banco                   format "99999999999" at 073.

    if  {1} < today then
        put stream relat
        day(tt-param.da-pagto)                             format "99" at 084
        month(tt-param.da-pagto)                           format "99" at 086
        substr(string(year(tt-param.da-pagto),"9999"),3,2) format "99" at 088.
    else
        put stream relat
        day({1})                                          format "99" at 084
        month({1})                                        format "99" at 086
        substr(string(year({1}),"9999"),3,2)              format "99" at 088.

    put stream relat
        {3} * 100                              format "9999999999999" at 090
        de-juros                               format "9999999999999" at 103
        de-abatimen                            format "9999999999999" at 116
        de-desconto                            format "9999999999999" at 129
        de-valor-pag                           format "9999999999999" at 142
        de-multa                               format "9999999999999" at 155
        i-num-reg                                     format "999999" at 315.
end.

/*--- DOCUMENTOS DE OUTROS BANCOS ---*/
if  tt-param.i-tipo-pag = 31 then do:

    assign c-linha-check1 = string(i-nr-banco,"9999") + "00000000000000"
           de-calc-check  = dec(c-linha-check1)
           c-linha-check2 = string((de-calc-check + de-valor-pag) * 5)
           de-linha-check = 0.

    if  length(c-linha-check2) > 18 then
        assign c-linha-check2 = substr(c-linha-check2, length(c-linha-check2) - 17, 18).
    else 
        if length(c-linha-check2) < 18 then
           assign de-linha-check = dec(c-linha-check2).

    put stream relat
        "2"                                                           at 001
        substr(cta-corrente.agencia-extrato,3,4)        format "9999" at 002
        fn-preenche-campo(cta-corrente.conta-corren-ext,7) 
                                                     format "9999999" at 006
        "0"                                                           at 033
        i-nr-banco                                                    at 034
        "4"                                                           at 051
        "0"                                                           at 052
        "5"                                                           at 053
        "9"                                                           at 054
        de-valor-pag                           format "9999999999999" at 055.

    find first emitente 
         where emitente.cod-emitente = {4} no-lock no-error.

    if  avail emitente then
        assign de-cgc = dec(emitente.cgc).
        put stream relat
            de-cgc                           format "999999999999999" at 068.

    put stream relat
        day(today)                                        format "99" at 083
        month(today)                                      format "99" at 085
        substr(string(year(today),"9999"),3,2)            format "99" at 087.

    if  {1} < today then
        put stream relat
        day(tt-param.da-pagto)                             format "99" at 089
        month(tt-param.da-pagto)                           format "99" at 091
        substr(string(year(tt-param.da-pagto),"9999"),3,2) format "99" at 093.
    else
        put stream relat
        day({1})                                          format "99" at 089
        month({1})                                        format "99" at 091
        substr(string(year({1}),"9999"),3,2)              format "99" at 093.

    put stream relat
        fn-free-accent(caps(c-nome))                   format "x(30)" at 095.

    if  tt-digita.log-leitora = yes then
        put stream relat
            "CDB"                                                     at 125
            trim(tt-digita.c-cod-barras)               format "x(44)" at 128.
    else
        put stream relat trim(tt-digita.c-cod-barras)  format "x(47)" at 125.

    put stream relat
        tt-digita.titulo-banco                   format "99999999999" at 197
        string({5})                                    format "x(15)" at 220
        "14"                                                          at 235
        day({1})                                          format "99" at 242
        month({1})                                        format "99" at 244
        substr(string(year({1}),"9999"),3,2)              format "99" at 246.

    if  i-tipo-mov <> 1 then
        put stream relat
            dec({2})                             format "99999999999" at 248.

    put stream relat
        i-tipo-mov                                        format "99" at 259.

        if de-linha-check > 0 then
           put stream relat 
               de-linha-check                                         at 263.
        else
           put stream relat
               c-linha-check2                                         at 263.

    put stream relat
        substr(cta-corrente.agencia-extrato,3,4)                      at 281
        /* n∆o Ç enviado o c¢digo do cedente por n∆o se ter essa 
           informaá∆o dispon°vel; o banco n∆o consiste esse dado */
        i-num-reg format "999999"                                     at 315.
end.

put stream relat skip.

/* Fim ap1001p.i3 */
