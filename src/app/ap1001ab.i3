/***************************************************************************
** ap1001ab.i3
** Objetivo: Gerar detalhe (compromisso) para o banco BANDEIRANTES.
***************************************************************************/

assign i-num-seq       = i-num-seq + 1
       c-uso-banco-ita = tt-digita.ita-uso-banco.
        
if tt-param.i-tipo-pag = 1
or tt-param.i-tipo-pag = 2
or tt-param.i-tipo-pag = 3 then
   assign c-tipo-com = "DUP".
   
if tt-param.i-tipo-pag = 1 then 
   assign c-tipo-pgban = "CC".

if tt-param.i-tipo-pag = 2 then
   assign c-tipo-pgban = "CHQ".
   
if tt-param.i-tipo-pag = 3 then
   assign c-tipo-pgban = "DOC".
   
if tt-param.i-tipo-pag = 30
or tt-param.i-tipo-pag = 31 then
   assign c-tipo-com   = "BLQ"
          c-tipo-pgban = "BLQ".
          
/*
assign c-aux      = ""
       de-inscric = 0.
/*-- Rotina para pegar somente os numeros do cgc
     quando o format for x(18) no emitente --*/
do   i-con = 1 to length(emitente.cgc):
     assign c-cgc = substr(emitente.cgc,i-con,1).
     if  can-do("0,1,2,3,4,5,6,7,8,9",c-cgc) then
         assign c-aux = c-aux + c-cgc.
end.
assign c-aux      = "0" + c-aux
       de-inscric = dec(c-aux).
*/

if  emitente.natureza = 2 then
    assign i-natureza = 01.
else
    if  emitente.natureza = 1 then
        assign i-natureza = 02.
        
find first cta-corrente 
     where cta-corrente.cod-banco    = portador.cod-banco
     and   cta-corrente.agencia      = portador.agencia
     and   cta-corrente.conta-corren = portador.conta-corren
     no-lock no-error.
        

put stream relat
    "1"                                                               at 001
    i-natureza                                            format "99" at 002
    c-cgc-emp                                 format "99999999999999" at 004
    tt-param.de-tipo-band                         format "9999999999" at 018
    substr(cta-corrente.agencia-extrato, 01,07)      format "9999999" at 029
    {6}.cod-estabel                                    format "x(03)" at 038
    {6}.cod-esp                                        format "x(03)" at 041
    {6}.serie                                          format "x(03)" at 044
    {6}.nr-docto                                    format "99999999" at 047
    {6}.parcela                                        format "x(02)" at 055
    emitente.cod-emitente                             format "999999" at 057
    de-inscric                                format "99999999999999" at 063
    c-tipo-com                                         format "x(03)" at 077
    string({5})                                        format "x(10)" at 080
    "C"                                                               at 108
    i-tipo-mov                                            format "99" at 109
    string({2})                                        format "x(10)" at 111  
    day({1})                                              format "99" at 121
    month({1})                                            format "99" at 123
    substr(string(year({1}),"9999"),3,2)                  format "99" at 125
    ({3} * 100)                                format "9999999999999" at 127
    c-tipo-pgban                                       format "x(03)" at 140
    i-nr-banco                                           format "999" at 143
    c-agencia                                        format "9999999" at 146
    "000"                                                             at 153
    c-cc-forn                                     format "9999999999" at 156.

    if tt-param.i-tipo-pag = 1 
    or tt-param.i-tipo-pag = 30 then
       put stream relat
           substr(portador.agencia, 01,07)           format "9999999" at 186.
    else
       if tt-param.i-tipo-pag = 1 then
          put stream relat
              emitente.agencia                       format "9999999" at 186.
       else 
          put stream relat
              tt-param.i-agencia                     format "9999999" at 186.       

put stream relat
    {4}                                             format "99999999" at 238
    "00"                                                              at 246
    portador.cod-banco                                   format "999" at 248
    (de-desconto)                              format "9999999999999" at 251
    emitente.nome-emit                                 format "x(40)" at 264.

if  tt-digita.log-leitora = yes then        
    put stream relat
        tt-digita.c-cod-barras                         format "x(44)" at 304.
else 
    put stream relat
        tt-digita.c-cod-barras                         format "x(44)" at 304.

put stream relat
    de-juros                                   format "9999999999999" at 348.

if  {1} < today then
    put stream relat
        day(tt-param.da-pagto)                             format "99" at 361
        month(tt-param.da-pagto)                           format "99" at 363
        substr(string(year(tt-param.da-pagto),"9999"),3,2) format "99" at 365.
else
    put stream relat
        day({1})                                          format "99" at 361
        month({1})                                        format "99" at 363
        substr(string(year({1}),"9999"),3,2)              format "99" at 365.
put stream relat
    de-valor-pag                               format "9999999999999" at 367
    "R$"                                               format "x(04)" at 380
     i-num-seq                                        format "999999" at 395.

/* ap1001ab.i2 */
