/***************************************************************************
***
***  app/ap1001d.i3 - Include usada na ap1001d.i2
***
***************************************************************************/

assign i-nr-docto = 0
       i-parcela  = 0.

if  tt-digita.log-leitora = no then do:
    assign i-cod-barra =  string(substring(tt-digita.c-cod-barras,01,04), "9999")
                        + string(substring(tt-digita.c-cod-barras,33,01), "9")
                        + string(substring(tt-digita.c-cod-barras,34,14), "99999999999999")
                        + string(substring(tt-digita.c-cod-barras,05,05), "99999")
                        + string(substring(tt-digita.c-cod-barras,11,10), "9999999999")
                        + string(substring(tt-digita.c-cod-barras,22,10), "9999999999").                        
end.
else
    assign c-cod-barras = string(substring(tt-digita.c-cod-barras,01,44)).

assign c-carteira      = tt-digita.ita-carteira
       l-aceite        = tt-digita.ita-aceite
       c-uso-banco-ita = tt-digita.ita-uso-banco
       de-carteira     = if length(c-carteira) > 3 then
                            dec(substr((c-carteira), length(c-carteira) - 2,3))
                         else    
                            dec(c-carteira).

put stream relat
    "1"                                                               at 001
    emitente.natureza                                      format "9" at 002.

if  emitente.natureza = 1 then
    put stream relat
        dec(substr(c-aux,1,9))                     format "999999999" at 003
        "0000"                                                        at 012
        substr(c-aux,10,2)                              format "x(2)" at 016.
else
    put stream relat
        dec(c-aux)                           format "999999999999999" at 003.

put stream relat
    c-nome                                             format "x(30)" at 018
    c-endereco                                         format "x(40)" at 048
    i-cep                                           format "99999999" at 088
    i-nr-banco                                           format "999" at 096.

if i-nr-banco <> 237 and i-tipo-pag = 31 then do:
    put stream relat
        0                                                      format "99999" at 099
        0                                                       format "9"    at 104
        0                                                       format "999"  at 105
        0                                                 format "9999999999" at 108
        0                                                         format "99" at 118.
end.
else do:
    put stream relat
        int(substr(c-agencia,2,5))                             format "99999" at 099
        substr(c-agencia,7,1)                                   format "x(1)" at 104
        "000"                                                                 at 105
        substr(c-cc-forn, 01,10)                          format "9999999999" at 108
        substr(c-cc-forn, 11,02)                               format "x(02)" at 118.
end.

if l-antecipacao = no then do:
    /* No envio das transacoes CAN, SUS, CSP e ALT devemos enviar a data do arquivo de remessa */
    if can-do("10,11,12,15", string(mov-ap.transacao)) then do:
        /* Encontra o movimento de implanta‡Æo ou de substitui‡Æo */
        find first b-mov-ap
             where b-mov-ap.ep-codigo    = tit-ap.ep-codigo
               and b-mov-ap.cod-fornec   = tit-ap.cod-fornec
               and b-mov-ap.cod-estabel  = tit-ap.cod-estabel
               and b-mov-ap.cod-esp      = tit-ap.cod-esp
               and b-mov-ap.serie        = tit-ap.serie
               and b-mov-ap.nr-docto     = tit-ap.nr-docto
               and b-mov-ap.parcela      = tit-ap.parcela
               and can-do("1,6", string(b-mov-ap.transacao)) no-lock no-error.

        if avail b-mov-ap and b-mov-ap.data-2 <> ? then
            put stream relat
               	    string(year(b-mov-ap.data-2),"9999")        format "9999" at 120
	            month(b-mov-ap.data-2)                      format   "99" at 124
	            day(b-mov-ap.data-2)                        format   "99" at 126
		    string(b-mov-ap.num-id-mov-ap,"99999999")                 at 128.
    end.
    else do:
        put stream relat
                string(year(today),"9999")                          format "9999" at 120
	        month(today)                                        format   "99" at 124
	        day(today)                                          format   "99" at 126
	        string({5},"99999999")                                            at 128.

        if mov-ap.transacao = 1 or mov-ap.transacao = 6 then do:
                find b-mov-ap where rowid(b-mov-ap) = rowid(mov-ap) exclusive-lock no-error.

                if avail b-mov-ap then
                        assign b-mov-ap.data-2 = today.                
        end.
    end.                
end.
else 
    put stream relat                                            
        substr(string(year(TODAY),"9999"),3,2)        format "99"         at 120
        month(today)                                  format "99"         at 122
        day(today)                                    format "99"         at 124
        {5}                                           format "9999999999" at 126.

if (i-tipo-pag = 31 or i-tipo-pag = 30) and i-nr-banco = 237 then do:
   if  tt-digita.log-leitora = yes then
       put stream relat    
           "0"                                                        at 136 
           substr(c-cod-barras,24,2)                      format "99" at 137
           "0"                                                        at 139 
           substr(c-cod-barras,26,2)                      format "99" at 140
           substr(c-cod-barras,28,9)               format "999999999" at 142.
   else
       put stream relat    
           "0"                                                        at 136 
           substr(i-cod-barra,24,2)                       format "99" at 137
           "0"                                                        at 139
           substr(i-cod-barra,26,2)                       format "99" at 140
           substr(i-cod-barra,28,9)                format "999999999" at 142.
end.       
else
   put stream relat
       "000"                                                          at 136
       "000"                                                          at 139
       "000000000"                                                    at 142.  

if i-tipo-pag = 30 then
    put stream relat
        {5}                               format "999999999999999"   at 151.

put stream relat
    string(year({3}), "9999")                           format "9999" at 166
    month({3})                                            format "99" at 170
    day({3})                                              format "99" at 172
    "00000000"                                                        at 174.

/* Guarda em de-valor-doc o valor do documento, pois se o valor nÆo for
   maior que zero nÆo grava a data e valor do desconto.  */          

if  (i-tipo-pag = 30 or
     i-tipo-pag = 31) then do:
    if  length(tt-digita.c-cod-barras) = 44 then
        assign de-valor-doc = dec(substr(tt-digita.c-cod-barras,6,14)).
    else
        assign de-valor-doc = dec(substr(tt-digita.c-cod-barras,34)).   
end.
else
   assign de-valor-doc = {4} * 100.

if  l-antecipacao = no then do:
    if  tit-ap.vl-desconto  > 0 
    and tit-ap.dt-desconto <> ? 
    and {4} * 100          > 0 then do:
        put stream relat
            string(year(tit-ap.dt-desconto), "9999")    format "9999" at 182
            month(tit-ap.dt-desconto)                     format "99" at 186
            day(tit-ap.dt-desconto)                       format "99" at 188.
    end.
    else do:
        put stream relat
           "00000000"                                                at 182.  
    end.
end.
else do:
    put stream relat
       "00000000"                                                    at 182.  
end.

if  l-antecipacao = no then do:
if  tit-ap.nr-bordero <> 0
and can-find(first funcao
             where funcao.cd-funcao = 'SPP-PAGTO-BORD-PARC'  
               and funcao.ativo = yes ) then
    put stream relat
        de-valor-pag                         format "999999999999999" at 190.
    else
        put stream relat
            de-valor-doc                         format "999999999999999" at 190.
end.
else
    put stream relat
        de-valor-doc                         format "999999999999999" at 190.

assign i-nr-docto = int(substr(tit-ap.nr-docto,01,08))
       i-parcela  = int(tit-ap.parcela)  no-error.
       

put stream relat
    de-valor-pag                             format "999999999999999" at 205
    (de-desconto)                            format "999999999999999" at 220
    (de-juros)                               format "999999999999999" at 235
    "04"                                                              at 250
    i-nr-docto                               format "99999999"        at 252
    i-parcela                                format "99"              at 260.

if i-tipo-pag = 30 then 
   put stream relat
   "31"                                                         at 264.
else if i-tipo-pag = 7
     or i-tipo-pag = 8
     or i-tipo-pag = 41
     or i-tipo-pag = 43 then
        put stream relat
        "08"                                     format "99" at 264.    
    else
       put stream relat
       i-tipo-pag                                    format "99" at 264.

if  {3} < today then
    put stream relat
    year(tt-param.da-pagto)                             format "9999" at 266
    month(tt-param.da-pagto)                              format "99" at 270
    day(tt-param.da-pagto)                                format "99" at 272.    
else
    put stream relat
    year({3})                                           format "9999" at 266
    month({3})                                          format "99"   at 270
    day({3})                                            format "99"   at 272.    

put stream relat    
    "01"                                                              at 277  
    i-tipo-mov                                                        at 289
    c-cod-mov                                                         at 290.

if  (i-tipo-pag = 30 or i-tipo-pag = 31) then do:
    if tt-digita.log-leitora = yes then
       put stream relat 
           substr(c-cod-barras,20,25) format "9999999999999999999999999" at 374
           substr(c-cod-barras,5,1)   format "9" at 399
           substr(c-cod-barras,4,1)   format "9" at 400.
    else
       put stream relat 
           substr(i-cod-barra,20,25) format "9999999999999999999999999" at 374
           substr(i-cod-barra,5,1)   format "9" at 399
           substr(i-cod-barra,4,1)   format "9" at 400.
end.        
else do:
    if  i-tipo-pag = 03
    or  i-tipo-pag = 07
    or  i-tipo-pag = 08  then 
        put stream relat 
            tt-param.c-tipo-docum                           format "x(1)" at 374
            "000000"                                                      at 375
            tt-param.i-finalidade                             format "99" at 381
            tt-param.i-agenc-bos                              format "99" at 383.    

    else do:
        if  i-tipo-pag = 01 then
            put stream relat
                "  "                                          format "99" at 383.
        
        else
            put stream relat
                "00"                                          format "99" at 383.     
                
    end.
            

            /*Utilizado o campo TT-PARAM.I-AGENC-BOS para gravar o tipo
              da conta para modalidade DOC/TED para que nÆo fosse 
              necess rio criar outro campo na temp-table*/     
end.

put stream relat
    "00"                                                              at 414  
    string({2})                                        format "x(35)" at 416
    "00000"                                                           at 473.
    
if  i-tipo-pag = 01 then
    put stream relat
        tt-param.i-conta-bos                               format "9" at 479.
else 
    put stream relat
        "1"                                                           at 479.

put stream relat  
    tt-param.conta-compl                             format "9999999" at 480
    i-hea-qua + 2                                     format "999999" at 495
    skip.

/* Fim de Include */

