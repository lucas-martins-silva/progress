/************************************************************************
***
***  app/ap1001aa.i3 - Usada na include ap1001a.i2
***  Padrao CNAB240.
***
************************************************************************/
if  tt-digita.log-leitora = no then  
    assign c-cod-barras = string(dec(substring(tt-digita.c-cod-barras,01,04)), "9999")
                          + string(dec(substring(tt-digita.c-cod-barras,33,01)), "9")
                          + string(dec(substring(tt-digita.c-cod-barras,34,14)), "99999999999999")
                          + string(dec(substring(tt-digita.c-cod-barras,05,05)), "99999")
                          + string(dec(substring(tt-digita.c-cod-barras,11,10)), "9999999999")
                          + string(dec(substring(tt-digita.c-cod-barras,22,10)), "9999999999").                        
else
    assign c-cod-barras = tt-digita.c-cod-barras.

 assign i-num-reg-1 = i-num-reg-1 + 1. 
 
 assign i-hea-qua = if i-hea-qua = 0 then 1 else i-hea-qua.

/* --- Titulo Banco do Brasil ------ Titulo Outro Banco     --- */
if  tt-param.i-tipo-pag = 30  or  tt-param.i-tipo-pag = 31  then do:  
 
    /*---------------- Registro 3 - Segmento J ------------------*/
    put stream relat
    "001"                                    format "999"               at 001
    i-num-reg                                format "9999"              at 004
    "3"                                      format "9"                 at 008
    i-hea-qua                                format "99999"             at 009
    "J"                                      format "x(01)"             at 014.

    if  l-antecipacao = no then do:
        if mov-ap.transacao = 10 then do:
            put stream relat
            "9"                                  format "9"                 at 015
            "27"                                 format "99"                at 016.
        end.
        else do:
            put stream relat
            "0"                                  format "9"                 at 015
            "00"                                 format "99"                at 016.
        end.
    end.
    else do:
        put stream relat
        "0"                                  format "9"                 at 015
        "00"                                 format "99"                at 016.
    end.
    
    put stream relat
    c-cod-barras                             format "x(44)"             at 018                    
    fn-free-accent(caps(c-nome))             format "x(20)"             at 062
    "/"                                                                 at 082
    {3}                                      format "999999999"         at 083
    day({1})                                 format "99"                at 092
    month({1})                               format "99"                at 094
    year({1})                                format "9999"              at 096
    {2} * 100                                format "999999999999999"   at 100
    (de-desconto + de-abatimen)              format "999999999999999"   at 115
    (de-juros    + de-multa)                 format "999999999999999"   at 130
    day({1})                                 format "99"                at 145
    month({1})                               format "99"                at 147
    year({1})                                format "9999"              at 149
    de-valor-pag                             format "999999999999999"   at 153
    "000000000000000"                        format "999999999999999"   at 168
    string({4})                              format "x(20)"             at 183 
    ""                                       format "x(01)"             at 240
    skip.
end.    
else do:    /* 01 - Credito em Conta Corrente    |    03 - DOC */

    /*----------- Registro 3 - Segmento A -------------*/
    put stream relat    
    "001"                                    format "999"               at 001
    i-num-reg                                format "9999"              at 004
    "3"                                      format "9"                 at 008
    i-hea-qua                                format "99999"             at 009
    "A"                                      format "x(01)"             at 014.

    if  l-antecipacao = no then do:
        if mov-ap.transacao = 10 then do:
            put stream relat
            "9"                                  format "9"                 at 015
            "27"                                 format "99"                at 016.
        end.
        else do:
            put stream relat
            "0"                                  format "9"                 at 015
            "00"                                 format "99"                at 016.
        end.
    end.
    else do:
        put stream relat
        "0"                                  format "9"                 at 015
        "00"                                 format "99"                at 016.
    end.

    if tt-param.i-tipo-pag = 03 then do:       /* Se Tipo Pagto = DOC */
        put stream relat
        "700"                                format "999"               at 018.
    end.
    else do:
        if tt-param.i-tipo-pag = 41            /* Se Tipo Pagto = TED Mesma Titularidade */
        or tt-param.i-tipo-pag = 43 then do:   /* Se Tipo Pagto = TED Outra Titularidade */
            put stream relat
            "018"                            format "999"               at 018.
        end.
        else do:
            put stream relat
            "000"                            format "999"               at 018.
        end.
    end.

    put stream relat
    i-nr-banco                               format "999"               at 021
    int(substr(c-agencia,2,5))               format "99999"             at 024
    substr(c-agencia,7,1)                    format "x(01)"             at 029
    "00"                                     format "99"                at 030
    substr(c-cc-forn, 01,10)                 format "9999999999"        at 032
    substr(c-cc-forn, 11,01)                 format "x(01)"             at 042
    substr(c-cc-forn, 12,01)                 format "x(01)"             at 043
    fn-free-accent(caps(c-nome))             format "x(20)"             at 044
    "/"                                                                 at 064
    {3}                                      format "999999999"         at 065
    string({4})                              format "x(20)"             at 074
    day({1})                                 format "99"                at 094
    month({1})                               format "99"                at 096
    year({1})                                format "9999"              at 098
    "BRL"                                    format "x(03)"             at 102
    fill("0",15)                             format "9(15)"             at 105
    de-valor-pag                             format "999999999999999"   at 120
    fill("0",08)                             format "99999999"          at 155
    fill("0",15)                             format "999999999999999"   at 163
    "0"                                      format "9"                 at 230
    ""                                       format "x(01)"             at 240
    skip.
 
    assign i-num-reg-1 = i-num-reg-1 + 1. 
           i-hea-qua   =  i-hea-qua + 1.

    /*----------- Registro 3 - Segmento B -------------*/
    put stream relat    
        "001"                                format "999"               at 001
        i-num-reg                            format "9999"              at 004
        "3"                                  format "9"                 at 008
        i-hea-qua                            format "99999"             at 009
        "B"                                  format "x(01)"             at 014.
    
    if  emitente.natureza = 1 then 
        put stream relat
            "1"            at 018.
    else         
        put stream relat
            "2"            at 018.
            
    put stream relat 
        de-inscric                           format "99999999999999"    at 019
        "00000"                                                         at 063
        "00000"                                                         at 118
        day({1})                             format "99"                at 128
        month({1})                           format "99"                at 130
        year({1})                            format "9999"              at 132
        ({2} * 100) - (de-desconto + de-abatimen) + (de-juros + de-multa)
                                             format "999999999999999"   at 136
        "000000000000000"                                               at 151
        "000000000000000"                                               at 166
        "000000000000000"                                               at 181
        "000000000000000"                                               at 196        
         fill(" ",15)                         format "x(15)"            at 226.
    
end.

/* Fim de Include */
        
