/***************************************************************************
***
***  app/ap1001q.i3 - Include usada na ap1001q.i2
***
***************************************************************************/

case tt-param.i-tipo-pag :
    when 1  then assign i-tipo-pag = 72.
    when 2  then assign i-tipo-pag = 73.
    when 3  then assign i-tipo-pag = 71.
    when 30 then assign i-tipo-pag = 81.
    when 31 then assign i-tipo-pag = 81.
    when 83 then assign i-tipo-pag = 83.
    when 85 then assign i-tipo-pag = 85.        
end case.    
    
assign c-cod-barras = string(substring(tt-digita.c-cod-barras,01,47)).

assign c-carteira      = tt-digita.ita-carteira
       l-aceite        = tt-digita.ita-aceite
       c-uso-banco-ita = tt-digita.ita-uso-banco
       de-carteira     = if length(c-carteira) > 3 then
                            dec(substr((c-carteira), length(c-carteira) - 2,3))
                         else    
                            dec(c-carteira).
                            
put stream relat
    "PAY"                                                           at 001
    "076"                                                           at 004
    tt-param.d-conta-cosmos                     format "9999999999" at 007.
    if  {2} < today then
        put stream relat 
        substr(string(year(tt-param.da-pagto),"9999"),3,2) format "99"   at 017
        month(tt-param.da-pagto)                           format "99"   at 019
        day(tt-param.da-pagto)                             format "99"   at 021.    
    else 
        put stream relat 
        substr(string(year({2}),"9999"),3,2)          format "99"   at 017
        month({2})                                    format "99"   at 019
        day({2})                                      format "99"   at 021.    

put stream relat
    "0"                                                             at 023
    string(i-tipo-pag)                                  format "99" at 024
    string({1})                                      format "x(15)" at 026.
    
if l-antecipacao = no then    
    put stream relat        
        dec(mov-ap.num-id-mov-ap)                    format "99999999" at 041.
else    
    put stream relat        
        dec(bordero-ap.int-2)                        format "99999999" at 041.

    
put stream relat    
    de-inscric                              format "99999999999999" at 049
    "R$"                                                            at 063.
    
if l-antecipacao = no then    
   put stream relat
       tit-ap.cod-fornec                        format "9999999999" at 066.
else
   put stream relat
       bordero-ap.cod-fornec                    format "9999999999" at 066.

put stream relat    
    de-valor-pag                           format "999999999999999" at 076
    "000000"                                                        at 091.
    
if l-antecipacao = no then 
   put stream relat
       "E"                                            format "x(01)" at 97
       tit-ap.cod-esp                                 format "x(02)" at 98
       tit-ap.nr-docto                                format "x(16)" at 100
       tit-ap.parcela                                 format "x(02)" at 116
       tit-ap.cod-fornec                              format "999999999" at 118.
else    
   put stream relat
       "E"                                            format "x(01)" at 97
       bordero-ap.cod-esp                             format "x(02)" at 98
       bordero-ap.nr-docto                            format "x(16)" at 100
       bordero-ap.parcela                             format "x(02)" at 116
       bordero-ap.cod-fornec                          format "999999999" at 118.

put stream relat
      ".                             "             format "x(30)" at 127.

assign c-tipo-docto = string(p-tipo-docto).

put stream relat    
    "000000"                                                         at 157
    dec(substring(c-tipo-docto, 1,2))              format "99"       at 163
    "01"                                                             at 165
    c-nome                                         format "x(80)"    at 167
    c-endereco                                     format "x(30)"    at 247    
    c-cidade                                       format "x(15)"    at 277
    c-estado                                       format "x(02)"    at 292
    i-cep                                          format "99999999" at 294
    "00000000000"                                                    at 302.
    
    
if (i-nr-banco = 745 and i-tipo-pag = 72) 
or  i-tipo-pag = 73 
or  i-tipo-pag = 81 then
    put stream relat    
        0                                     format "999"             at 313
        0                                     format "9999"            at 316
        " "                                   format "x(04)"           at 320
        0                                     format "999999999999999" at 324.
else
    put stream relat    
        i-nr-banco                                     format "999"      at 313
        int(substr(c-agencia,3,4))                     format "9999"     at 316
        " "                                            format "x(04)"    at 320
        dec(fn-troca(c-cc-forn))                       format "999999999999999" at 324.


if  i-tipo-pag = 071 
or  i-tipo-pag = 083
or  i-tipo-pag = 085 then
    put stream relat
        "01"                                                        at 340.
else
    put stream relat      
        "00"                                                        at 340.
        
put stream relat
    "0000000000"                                                    at 389.
        
if   i-nr-banco = 745 
and (i-tipo-pag = 71 or i-tipo-pag = 72) /*tipo de pagto CRED em CC ou DOC*/
and  c-cc-forn <> " "  then do:
    put stream relat
        dec(substr(fn-troca(c-cc-forn),1,10))         format "9999999999" at 434
        "01"                                                              at 444.
end.        
else do:
    put stream relat
        "0000000000"                                              at 434
        "00"                                                      at 444.
end.        

put stream relat
    tt-param.c-filial                              format "x(03)" at 446.
    
if  (i-tipo-pag = 081)
and c-cod-barras <> "" then
       put stream relat
           c-cod-barras                                format "x(50)" at 449.

put stream relat
    "     "                                                           at 499.
    
put stream relat
   " "                                                                at 600
skip.

assign i-movimento = i-movimento + 1.


/* Fim de Include */

