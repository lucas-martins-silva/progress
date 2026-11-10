/***************************************************************************
***
***  app/ap1001i.i3 - Include usada na ap1001i.i2
***
***************************************************************************/

assign i-num-reg       = i-num-reg + 1
       c-carteira      = tt-digita.ita-carteira
       l-aceite        = tt-digita.ita-aceite
       c-uso-banco-ita = tt-digita.ita-uso-banco
       de-carteira     = if length(c-carteira) > 3 then
                            dec(substr((c-carteira), length(c-carteira) - 2,3))
                         else    
                            dec(c-carteira).                         

if  tt-digita.log-leitora = no then
    assign c-cod-barras = substring(tt-digita.c-cod-barras,01,04)
                        + substring(tt-digita.c-cod-barras, 33,01)
                        + string(dec(substring(tt-digita.c-cod-barras,34,14)), "99999999999999")
                        + substring(tt-digita.c-cod-barras, 05,05)
                        + substring(tt-digita.c-cod-barras, 11,10)
                        + substring(tt-digita.c-cod-barras, 22,10).
else
    assign c-cod-barras = tt-digita.c-cod-barras.
    
/*---- acerto do formato da conta corrente ----*/

assign c-digito-cta1  = substring(c-cc-forn, 11, 1)
       c-digito-cta2  = substring(c-cc-forn, 12, 1).

if  c-digito-cta1 <> " "
and c-digito-cta2 = " " then 
  assign c-cc-forn =  substring(c-cc-forn, 2, 9) +
                           c-digito-cta1.

if  c-digito-cta1 = " "
and c-digito-cta2 = " " then
    assign c-cc-forn = substring(c-cc-forn, 1, 10) .

if c-digito-cta1 <> " "
and c-digito-cta2 <> " " then    
    assign c-cc-forn = substring(c-cc-forn,3, 8) 
                     + c-digito-cta1 
                     + c-digito-cta2.                                                                                

/* ------- Acerto do formato da agencia -------- */
/* Se Ç DOC ou TED n∆o deve-se mandar o d°gito da agància */
if  tt-param.i-tipo-pag = 3  /* DOC */
or  tt-param.i-tipo-pag = 83 /* TED */ then
        assign c-agencia = substr(c-agencia, 1, 6).
else do:
        assign c-digito-cta1 = substr(c-agencia,7,1).

        if c-digito-cta1 <> " " then
            assign c-agencia = substr(c-agencia, 1, 6) + c-digito-cta1.
        else
           assign c-agencia = substr(c-agencia,1,7).        
end.

put stream relat
    "1"                                                               at 001
    "01"                                                  format "99" at 002
    c-cgc-emp                                 format "99999999999999" at 004
    tt-param.i-conta-bos                            format "99999999" at 018
    tt-param.i-agenc-bos                             format "9999999" at 029
    string({1})                                        format "x(20)" at 038
    de-inscric                                format "99999999999999" at 063
    "DUP"                                                             at 077
    caps(substr({4}, 1, 10))                      format "9999999999" at 080
    "TA"                                                              at 091
    "C"                                                               at 108
    i-tipo-mov                                            format "99" at 109
    day(today)                                            format "99" at 111
    month(today)                                          format "99" at 113
    substr(string(year(today),"9999"),3,2)                format "99" at 115
    day({2})                                              format "99" at 121
    month({2})                                            format "99" at 123
    substr(string(year({2}),"9999"),3,2)                  format "99" at 125
    {3} * 100                               format "9999999999999"    at 127.

if  tt-param.i-tipo-pag = 1 then
    put stream relat
        "CC"                                                          at 140
        "000"                                                         at 143.
if  tt-param.i-tipo-pag = 2 then
    put stream relat
        "CHQ"                                                         at 140
        "000"                                                         at 143.        

if  tt-param.i-tipo-pag = 3
or  tt-param.i-tipo-pag = 83 then
    put stream relat
        "DOC"                                                         at 140
        i-nr-banco                                                    at 143.

if  tt-param.i-tipo-pag = 30
or  tt-param.i-tipo-pag = 31 then
    put stream relat
        "COB"                                                         at 140
        "000"                                                         at 143.        



put stream relat
    substr(c-agencia, 1, 7)                           format "9999999" at 146.

if tt-param.i-tipo-pag = 83 then do:
    put stream relat
        "018"                                                         at 153.
end.
else do:
    if tt-param.i-tipo-pag = 3 then do:
        put stream relat
            "700"                                                     at 153.
    end.
    else do:
        put stream relat
            "000"                                                     at 153.
    end.
end.

put stream relat
    substr(c-cc-forn, 01,10)                      format "9999999999" at 156
    tt-param.i-agenc-bos                             format "9999999" at 186
    c-nome                                                            at 193
    de-desconto                                format "9999999999999" at 251
    fill("0",44 - length(trim(c-cod-barras))) +
    trim(substr(c-cod-barras, 1, 44))                  format "x(44)" at 264.

put stream relat    
    de-juros                                   format "9999999999999" at 348.
if  {2} < today then
    put stream relat
    day(tt-param.da-pagto)                                format "99" at 361
    month(tt-param.da-pagto)                              format "99" at 363
    substr(string(year(tt-param.da-pagto),"9999"),3,2)    format "99" at 365.
else
    put stream relat
    day({2})                                              format "99" at 361
    month({2})                                            format "99" at 363
    substr(string(year({2}),"9999"),3,2)                  format "99" at 365.

put stream relat
    de-valor-pag                               format "9999999999999" at 367
    "R$"                                                              at 380
    "N"                                                               at 384
    fill("0",02)                                       at 393 format "x(02)"
    i-num-reg                                         format "999999" at 395.







