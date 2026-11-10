/****************************************************************************
***
***  app/ap1001k.i3 - Include usada na ap1001k.i2.   
***
****************************************************************************/

assign c-carteira      = tt-digita.ita-carteira
       l-aceite        = tt-digita.ita-aceite
       c-uso-banco-ita = tt-digita.ita-uso-banco.
       
if  tt-digita.log-leitora = no then  
    assign c-cod-barras = string(dec(substring(tt-digita.c-cod-barras,01,04)), "9999")
                          + string(dec(substring(tt-digita.c-cod-barras,33,01)), "9")
                          + string(dec(substring(tt-digita.c-cod-barras,34,14)), "99999999999999")
                          + string(dec(substring(tt-digita.c-cod-barras,05,05)), "99999")
                          + string(dec(substring(tt-digita.c-cod-barras,11,10)), "9999999999")
                          + string(dec(substring(tt-digita.c-cod-barras,22,10)), "9999999999").                        
else
    assign c-cod-barras = tt-digita.c-cod-barras.    
  

/* Considera Desconto com o valor do Abatimento,
   Para Banco Safra ‚ somente considerada a posicao 251 a 263 para
   Descontos */   

put stream relat
    "1"                                                                 at 001
    "01"                                                                at 002
    c-cgc-emp                                   format "99999999999999" at 004
    dec(substr(cta-corrente.conta-corren-ext,4,8))    format "99999999" at 018
    int(substr(cta-corrente.agencia-extrato,1,7))      format "9999999" at 029
    {1}.cod-estabel                                      format "x(03)" at 038
    {1}.cod-esp                                          format "x(02)" at 041
    {1}.serie                                            format "x(03)" at 043
    {1}.nr-docto                                      format "99999999" at 046
    {1}.parcela                                          format "x(02)" at 054
    dec(c-aux)                                  format "99999999999999" at 063
    "DUP"                                                               at 077
    string({2})                                     format "9999999999" at 080.

if  tt-param.i-tipo-pag = 01 or
    tt-param.i-tipo-pag = 03 or
    tt-param.i-tipo-pag = 83 then do: 
        
    find first emitente
         where emitente.cod-emitente = {1}.cod-fornec no-lock no-error.
        
        if  emitente.natureza = 1 then 
            put stream relat
                "1"                                          format "x(01)" at 107.
        else         
            put stream relat
                "2"                                          format "x(01)" at 107.
end. 
           
put stream relat                
    "C"                                                                 at 108
    i-tipo-mov                                              format "99" at 109
    string({2})                                     format "9999999999" at 111
    day({3})                                                format "99" at 121
    month({3})                                              format "99" at 123
    substr(string(year({3}),"9999"),3,2)                    format "99" at 125
    {4} * 100                                    format "9999999999999" at 127.
    
if  tt-param.i-tipo-pag = 01 /*CC*/ then
    put stream relat "CC"                                               at 140.

if  tt-param.i-tipo-pag = 30 
or  tt-param.i-tipo-pag = 31 /*CO*/ then
    put stream relat "COB"                                              at 140.

if  tt-param.i-tipo-pag = 03 /*DO*/ then         
    put stream relat "DOC"                                              at 140.

if  tt-param.i-tipo-pag = 02 /*CH*/ then       
    put stream relat "CHQ"                                              at 140.

if  tt-param.i-tipo-pag = 83 /*TED CIP*/ then
    put stream relat "TED"                                              at 140.
 
if  tt-param.i-tipo-pag = 02 /*CH*/ then
    put stream relat "00000000000000000000000"                          at 143.
else do:
    put stream relat
    i-nr-banco                                             format "999" at 143.
  
    if  tt-param.i-tipo-pag <> 03
    and tt-param.i-tipo-pag <> 83 then
        put stream relat
        int(substr(c-agencia,1,7))                     format "9999999" at 146.
    else
        put stream relat  
        int(substr(c-agencia,1,6))                     format "9999999" at 146.
  
    put stream relat
    "00"                                                                at 153.
end.

if  tt-param.i-tipo-pag <> 02 /*CH*/ then do:
    if  c-cc-forn <> "" and c-cc-forn <> ? then do:
        if  tt-param.i-tipo-pag = 03 /*DOC*/
        or  tt-param.i-tipo-pag = 83 /*TED(CIP/outra titularid.)*/ then do:
            if substring(c-cc-forn,12,01) = "" then
                put stream relat
                    substring(c-cc-forn, 01, 11)       format "99999999999" at 155.
            else
                put stream relat
                    substring(c-cc-forn, 02, 11)       format "99999999999" at 155.    
        end.
        else
            put stream relat
                "0"                                                     at 155
                substring(c-cc-forn, 01, 10)        format "9999999999" at 156.
    end.
end.

find first agencia 
     where agencia.cod-banco = i-nr-banco 
     and agencia.agencia     = c-agencia no-lock no-error.
               
if  avail agencia then 
    if  tt-param.i-tipo-pag = 01 /*CC*/ 
    or  tt-param.i-tipo-pag = 03 /*DO*/ then
        put stream relat                                              
        agencia.nome                                     format "x(20)" at 166.
else 
    put stream relat
        ""                                               format "x(20)" at 166.

put stream relat
    substr(cta-corrente.agencia-extrato,1,6)            format "999999" at 186
    substr(cta-corrente.agencia-extrato,7,1)                 format "9" at 192.

if  tt-param.i-tipo-pag = 30
or  tt-param.i-tipo-pag = 31 /*C0B*/ then do:
    if  tt-digita.c-cod-barras <> " " then
        assign i-nr-banco = int(substr(tt-digita.c-cod-barras,1,3)).
    
    put stream relat i-nr-banco                           format "999"  at 248.
end.
else
    put stream relat "0000000000000000"                                 at 248.

if  tt-param.i-tipo-pag = 30
or  tt-param.i-tipo-pag = 31 /*C0B*/ then
    put stream relat de-desconto                 format "9999999999999" at 251.

put stream relat c-nome                                  format "x(40)" at 264.

if  tt-param.i-tipo-pag = 30
or  tt-param.i-tipo-pag = 31 /*C0B*/ then
    put stream relat c-cod-barras              format "x(44)" at 304.

if  tt-param.i-tipo-pag = 30
or  tt-param.i-tipo-pag = 31 /*C0B*/ then
    put stream relat (de-juros)                  format "9999999999999" at 348.
else 
    put stream relat "0000000000000"                                    at 348.

if  {3} < today then
    put stream relat
    day(tt-param.da-pagto)                                  format "99" at 361
    month(tt-param.da-pagto)                                format "99" at 363
    substr(string(year(tt-param.da-pagto),"9999"),3,2)      format "99" at 365.
else    
    put stream relat
    day({3})                                                format "99" at 361
    month({3})                                              format "99" at 363
    substr(string(year({3}),"9999"),3,2)                    format "99" at 365.

put stream relat
    de-valor-pag                                 format "9999999999999" at 367
    "REAL"                                                              at 380.

if  tt-param.i-tipo-pag = 30 
or  tt-param.i-tipo-pag = 31 /*C0*/ then
    put stream relat
    c-carteira                                          format "x(04)"  at 384
    {1}.cod-esp                                         format "x(02)"  at 388.

if  tt-param.i-tipo-pag = 01 /*CC*/
or  tt-param.i-tipo-pag = 03 /*DO*/ then 
    put stream relat substr(c-agencia,7,1)              format "x(01)"  at 392.

put stream relat i-hea-qua + 2                          format "999999" at 395
skip.

/* Fim de Include */
