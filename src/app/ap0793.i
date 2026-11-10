/*******************************************************************************
**     
**     ap0793.i - Saldo de fornecedores na data informada 
**
*******************************************************************************/

assign de-pago       = 0 
       de-saldo      = 0 
       de-nota-cr    = 0
       de-nota-db    = 0.
 
bloco:
do on error undo bloco, leave bloco:
   
assign de-pago  = 0
       de-saldo = 0.

for each mov-ap of tit-ap
    where mov-ap.dt-transacao > da-data-refer no-lock:

    if  mov-ap.transacao = 1 /*0*/ 
        then next.

    assign de-pago = de-pago + mov-ap.valor-mov.

end.

assign de-desconto = 0.

for each b-tit-ap 
    where b-tit-ap.ep-codigo     = tit-ap.ep-codigo 
    and   b-tit-ap.cod-estabel   = tit-ap.cod-estabel 
    and   b-tit-ap.cod-fornec    = tit-ap.cod-fornec
    and   b-tit-ap.docto-ant     = tit-ap.nr-docto
    and   b-tit-ap.esp-ant       = tit-ap.cod-esp 
    and   b-tit-ap.parc-ant      = tit-ap.parcela 
    and   b-tit-ap.serie-ant     = tit-ap.serie
    and   b-tit-ap.dt-transacao  > da-data-refer no-lock:

    if  l-previsao = no and (b-tit-ap.tipo = 3 or b-tit-ap.tipo = 10) then
        next.

    if  b-tit-ap.tipo = 4 then do:
        assign de-nota-cr = de-nota-db + b-tit-ap.vl-original.
        next. 
    end.    

    if  b-tit-ap.tipo = 5 then do:
        assign de-nota-cr = de-nota-cr + b-tit-ap.vl-original.
        next.
    end.
end.

end. /*bloco*/

assign de-saldo = tit-ap.valor-saldo
                  + de-pago
                  + de-nota-cr
                  - de-nota-db.

/* ap0793.i */
