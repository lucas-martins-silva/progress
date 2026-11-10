/****************************************************************************
** 
** Include.: ap1001ag.i3
**
** Objetivo: usado na include ap1001ag.i2.
**
****************************************************************************/


assign i-num-seq = i-num-seq + 1.

if  tt-digita.log-leitora = no then 
    assign c-cod-barras = string(dec(substring(tt-digita.c-cod-barras,01,04)), "9999")
                        + string(dec(substring(tt-digita.c-cod-barras,33,01)), "9")
                        + string(dec(substring(tt-digita.c-cod-barras,34,14)), "99999999999999")
                        + string(dec(substring(tt-digita.c-cod-barras,05,05)), "99999")
                        + string(dec(substring(tt-digita.c-cod-barras,11,10)), "9999999999")
                        + string(dec(substring(tt-digita.c-cod-barras,22,10)), "9999999999").
else
    assign c-cod-barras = tt-digita.c-cod-barras.
    
if  c-cod-barras = "" then
    assign c-cod-barras = "00000000000000000000000000000000000000000000".
    
if  tt-param.i-tipo-pag = 01 then
    assign c-tp-pag-bcn = "CC ".
else
    if  tt-param.i-tipo-pag = 03
    or  tt-param.i-tipo-pag = 83
    or  tt-param.i-tipo-pag = 85 then
        assign c-tp-pag-bcn = "DOC".
    else           
        if  tt-param.i-tipo-pag = 10 then
            assign c-tp-pag-bcn = "OP ".
        else
            if  tt-param.i-tipo-pag = 30
            or  tt-param.i-tipo-pag = 31 then
                assign c-tp-pag-bcn = "BLQ".
            else
                assign c-tp-pag-bcn = "COB".
    


if c-tp-pag-bcn = "DOC"
or c-tp-pag-bcn = "CC " then
   assign i-banco   = tt-digita.banco
          i-agencia = dec(substring(tt-digita.agencia,3,4))
          i-conta   = dec(substring(tt-digita.cta-corrente,1,10))
          c-digito  = substring(tt-digita.cta-corrente,11,2).
else
   assign i-banco   = 0
          i-agencia = 0
          i-conta   = 0
          c-digito  = "".

find first cta-corrente
     where cta-corrente.cod-banco    = portador.cod-banco
     and   cta-corrente.agencia      = portador.agencia
     and   cta-corrente.conta-corren = portador.conta-corren
     no-lock no-error.

if c-tp-pag-bcn = "BLQ" or c-tp-pag-bcn = "DOC" or c-tp-pag-bcn = "COB" then do:
   assign i-agencia-pag = dec(substring(cta-corrente.agencia-extrato,3,4)).
end.   
else do:
   if c-tp-pag-bcn = "CC " or  c-tp-pag-bcn = "OP "
   or tt-param.i-tipo-pag = 83 or tt-param.i-tipo-pag = 85 then
      assign i-agencia-pag = dec(substring(emitente.agencia,3,4)).
   else
      if c-tp-pag-bcn = "COB" then
         assign i-banco-port = portador.cod-banco.
      else
         assign i-banco-port = 0.
end.         

assign c-aux      = ""
       de-inscric = 0.

/*-- Rotina para pegar somente os numeros do cgc
     quando o format for x(18) da empresa --*/
do   i-con = 1 to length(empresa.cgc):
     assign c-cgc = substr(empresa.cgc,i-con,1).
     if  can-do("0,1,2,3,4,5,6,7,8,9",c-cgc) then
         assign c-aux = c-aux + c-cgc.
end.
assign c-aux          = "0" + c-aux
       de-inscric     = dec(c-aux)
       de-cgc-empr    = dec(c-aux).
       
/*-- Pegar a natureza do emitente --*/
if emitente.natureza = 2 then
   assign i-natureza = 1.  /* CGC */
else 
   if emitente.natureza = 1 then
      assign i-natureza = 2.  /* CPF */
   else
      assign i-natureza = 9.
      
put stream relat
    "1"                                                               at 001
    "01"                                                  format "99" at 002
    de-inscric                                format "99999999999999" at 004
    substring(cta-corrente.conta-corren-extr,5,7)    format "9999999" at 018
    substring(cta-corrente.agencia-extrato,3,4)         format "9999" at 034
    string({4})                                        format "x(25)" at 040.

assign c-aux      = ""
       de-inscric = 0.
/*-- Rotina para pegar somente os numeros do cgc
     quando o format for x(18) no emitente --*/
do   i-con = 1 to length(emitente.cgc):
     assign c-cgc = substr(emitente.cgc,i-con,1).
     if  can-do("0,1,2,3,4,5,6,7,8,9",c-cgc) then
         assign c-aux = c-aux + c-cgc.
end.
assign c-aux          = "0" + c-aux
       de-inscric     = dec(c-aux).
       de-cgc-emit    = dec(c-aux).

put stream relat
    de-inscric                                format "99999999999999" at 065
    "DUP"                                              format "x(03)" at 079.
    
if  l-antecipacao = no then do:
    put stream relat    
        tit-ap.serie                                       format "x(03)" at 082
        tit-ap.nr-docto                                 format "99999999" at 085
        tit-ap.parcela                                     format "x(02)" at 093
        "C"                                                               at 110
        i-tipo-mov                                            format "99" at 111
        tit-ap.nr-docto                                 format "99999999" at 113
        tit-ap.parcela                                     format "x(02)" at 121.
end.        
else do:
    assign i-tipo-mov = 1.
    put stream relat    
        bordero-ap.serie                                    format "x(03)"    at 082
        bordero-ap.nr-docto                                 format "99999999" at 085
        bordero-ap.parcela                                  format "x(02)"    at 093
        "C"                                                                   at 110
        i-tipo-mov                                          format "99"       at 111
        bordero-ap.nr-docto                                 format "99999999" at 113
        bordero-ap.parcela                                  format "x(02)"    at 121.
end.        

put stream relat
    day({1})                                              format "99" at 123
    month({1})                                            format "99" at 125
    year({1})                                           format "9999" at 127
    (de-valor-ori * 100)                       format "9999999999999" at 131
    c-tp-pag-bcn                                       format "x(03)" at 144
    i-banco                                              format "999" at 147.

if c-tp-pag-bcn = "DOC"
or c-tp-pag-bcn = "CC " then
    put stream relat
        "N"                                            format "x(01)" at 150.
else
    put stream relat
        "S"                                            format "x(01)" at 150.

put stream relat
    i-agencia                                           format "9999" at 151.

if tt-param.i-tipo-pag = 83 /* TED CIP */ then do:
    put stream relat
        "12"                                                          at 155.
end.
else do:
    if tt-param.i-tipo-pag = 85 /* TED STR */ then do:
        put stream relat
            "13"                                                      at 155.
    end.
    else do:
        if tt-param.i-tipo-pag = 3 /* DOC */ then do:
            put stream relat
                "19"                                                  at 155.
        end.
    end.
end.

if c-tp-pag-bcn = "CC " or 
   c-tp-pag-bcn = "DOC" then
    put stream relat
        "1"                                                           at 157.

put stream relat
    i-conta                                       format "9999999999" at 158
    c-digito                                           format "x(02)" at 168
    de-cgc-emit                              format "999999999999999" at 170.

if emitente.natureza = 2 then
   put stream relat
       "01"                                                           at 185. /* CGC */         
else 
   if emitente.natureza = 1 then
      put stream relat
       "02"                                                           at 185. /* CPF */
   
put stream relat
    "      "                                                          at 187
    i-agencia-pag                                       format "9999" at 193
    i-natureza                                            format "99" at 197
    emitente.nome-emit                                 format "x(30)" at 199
    "00020"                                                           at 229
    "   "                                                             at 252.
if  l-antecipacao = no then do:
    if  c-tp-pag-bcn = "BLQ" then
        put stream relat
            de-desconto                            format "9999999999999" at 255.
    else
        put stream relat 
            (tit-ap.vl-desconto * 100)             format "9999999999999" at 255.
end.
else do:
    if  c-tp-pag-bcn = "BLQ" then
        put stream relat
            de-desconto                            format "9999999999999" at 255.
    else
        put stream relat 
            (bordero-ap.vl-desconto * 100)             format "9999999999999" at 255.
end.        


put stream relat
    c-cod-barras                               format "x(44)"         at 268.

if  c-tp-pag-bcn = "BLQ" then
    put stream relat
        de-juros                               format "9999999999999" at 352.
else do:
    if l-antecipacao = no then do:
        put stream relat
            (tit-ap.vl-juros-conf * 100)           format "9999999999999" at 352.
    end.
    else do:
        put stream relat
            0                                      format "9999999999999" at 352.
    end.        
end.        

if l-antecipacao = no then do:
    put stream relat
        tit-ap.dt-vencimen                              format "99999999" at 365
        ((tit-ap.valor-saldo * 100) - de-desconto + de-juros )
                                                   format "9999999999999" at 373.
end.
else do:
    put stream relat
        bordero-ap.dt-vencto                              format "99999999" at 365
        ((bordero-ap.vl-docto * 100) - de-desconto + de-juros )
                                                     format "9999999999999" at 373.
end.                                                   

put stream relat
    "01"                                                              at 386
    "N"                                                               at 388
    i-num-seq                                         format "999999" at 395.

/* ap1001ag.i3 */
