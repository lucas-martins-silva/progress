/************************************************************************
***
***  app/ap1001a.i3 - Usada na include ap1001a.i2
***
************************************************************************/
if  tt-digita.log-leitora = no then
    assign c-cod-barras = substring(tt-digita.c-cod-barras,01,04)
                        + substring(tt-digita.c-cod-barras, 33,01)
                        + string(dec(substring(tt-digita.c-cod-barras,34,14)), "99999999999999")
                        + substring(tt-digita.c-cod-barras, 05,05)
                        + substring(tt-digita.c-cod-barras, 11,10)
                        + substring(tt-digita.c-cod-barras, 22,10).
else
    assign c-cod-barras = tt-digita.c-cod-barras.

assign i-num-reg = i-num-reg + 1.

if  tt-param.i-tipo-pag = 30
or  tt-param.i-tipo-pag = 31 then do:

    if  substr(string(c-cod-barras, "999"),1,3) = "000" then
        put stream relat 
        i-nr-banco                                       format "999" at 001.
    else
        put stream relat 
        substr(string(c-cod-barras, "999"),1,3)          format "999" at 001.
    put stream relat
    i-tipo-mov                                                        at 004
    day({1})                                              format "99" at 005    
    month({1})                                            format "99" at 007
    substr(string(year({1}),"9999"),3,2)                  format "99" at 009
    c-agencia                                                         at 011
    substr(c-cc-forn,2,12)                             format "x(12)" at 019
    tt-digita.titulo-banco                             format "x(20)" at 031
    {2} * 100                              format "99999999999999999" at 051
    c-nome                                             format "x(22)" at 068
    {3}                                                format "999999999" at 091.
    if  {1} < today then
        put stream relat
        day(tt-param.da-pagto)                            format "99" at 103
        month(tt-param.da-pagto)                          format "99" at 105
        substr(string(year(tt-param.da-pagto),"9999"),3,2)format "99" at 107.
    else
        put stream relat
        day({1})                                         format "99" at 103
        month({1})                                       format "99" at 105
        substr(string(year({1}),"9999"),3,2)             format "99" at 107.
    put stream relat        
    de-valor-pag                         format "99999999999999999"  at 109 
    (de-desconto)                        format "99999999999999999"  at 126
    (de-juros)                           format "99999999999999999"  at 143
    c-cod-barras                         format "x(44)"              at 160
    string({4})                          format "x(20)"              at 204
    "                 "                                              at 224
    skip.
end.
else do:
    put stream relat
    "1"                                                              at 001. 
    if  emitente.natureza = 1 then 
        put stream relat
            "2"            at 003.
    else         
        put stream relat
            "4"            at 003.
    put stream relat
    de-inscric                           format "99999999999999"     at 004
    string({4})                          format "x(10)"              at 033.
      
    if tt-param.i-tipo-pag = 03 then do:       /* Se Tipo Pagto = DOC */
        put stream relat
        "700"                                format "999"               at 057.
    end.
    else do:
        if tt-param.i-tipo-pag = 41            /* Se Tipo Pagto = TED Mesma Titularidade */
        or tt-param.i-tipo-pag = 43 then do:   /* Se Tipo Pagto = TED Outra Titularidade */
            put stream relat
            "018"                            format "999"               at 057.
        end.
        else do:
            put stream relat
            "000"                            format "999"               at 057.
        end.
    end.

    put stream relat        
        i-nr-banco                                                   at 060.
        
    put stream relat
    substr(c-agencia,3,4)                              format "9999" at 063
    substr(c-agencia,7,1)                                 format "9" at 067
    fill("0",13 - length(trim(c-cc-forn))) +
    trim(substr(c-cc-forn, 1, 13))            format "9999999999999" at 068
    c-nome                                            format "x(40)" at 083.  
    
    if  {1} < today then
        put stream relat
        day(tt-param.da-pagto)                            format "99" at 123
        month(tt-param.da-pagto)                          format "99" at 125
        substr(string(year(tt-param.da-pagto),"9999"),3,2)format "99" at 127.
    else
        put stream relat
        day({1})                                          format "99" at 123
        month({1})                                        format "99" at 125
        substr(string(year({1}),"9999"),3,2)              format "99" at 127.
    put stream relat
    de-valor-pag                             format "9999999999999"  at 129.
    if  tt-param.i-tipo-pag = 01 then
        put stream relat
        "002"                                                        at 142.
    else
        put stream relat
        "017"                                                        at 142.
    put stream relat
    i-num-reg                                       format "999999"  at 195
    skip.    
end.    

/* Fim ap1001a.i3 */
