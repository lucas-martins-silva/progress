/**************************************************************************
**
** app/ap0505ia.i - Valida‡äes de valores.
**
**************************************************************************/

assign de-vl-ret-original = 0
       de-vl-ret-credito  = 0
       de-vl-ret-debito   = 0
       de-vl-ret-saldo    = 0
       de-vl-iva          = 0
       de-vl-retencao     = 0
       de-vl-percepcao    = 0.

if  avail lin-b-ap then do:
    find first tit-ap use-index codigo
         where tit-ap.ep-codigo    = lin-b-ap.ep-codigo
         and   tit-ap.cod-estabel  = lin-b-ap.cod-estabel
         and   tit-ap.cod-esp      = lin-b-ap.cod-esp
         and   tit-ap.serie        = lin-b-ap.serie
         and   tit-ap.nr-docto     = lin-b-ap.nr-docto
         and   tit-ap.parcela      = lin-b-ap.parcela
         and   tit-ap.cod-fornec   = lin-b-ap.cod-fornec
         no-error.
    
    if  avail tit-ap then do:
        for each  impto-tit-ap use-index codigo
            where impto-tit-ap.ep-codigo    = tit-ap.ep-codigo
            and   impto-tit-ap.cod-estabel  = tit-ap.cod-estabel
            and   impto-tit-ap.cod-esp      = tit-ap.cod-esp
            and   impto-tit-ap.serie        = tit-ap.serie
            and   impto-tit-ap.nr-docto     = tit-ap.nr-docto
            and   impto-tit-ap.parcela      = tit-ap.parcela
            and   impto-tit-ap.cod-fornec   = tit-ap.cod-fornec
            and   impto-tit-ap.tipo         = 2:
            assign de-vl-ret-original = de-vl-ret-original + impto-tit-ap.vl-retencao.
        end. /* for each impto-tit-ap ... */
    end. /* if avail tit-ap ... */    
    
    for each  impto-tit-pend-ap use-index codigo
        where impto-tit-pend-ap.ep-codigo   = lin-b-ap.ep-codigo
        and   impto-tit-pend-ap.cod-estabel = lin-b-ap.cod-estabel
        and   impto-tit-pend-ap.cod-esp     = lin-b-ap.cod-esp
        and   impto-tit-pend-ap.serie       = lin-b-ap.serie
        and   impto-tit-pend-ap.nr-docto    = lin-b-ap.nr-docto
        and   impto-tit-pend-ap.parcela     = lin-b-ap.parcela
        and   impto-tit-pend-ap.cod-fornec  = lin-b-ap.cod-fornec
        and   impto-tit-pend-ap.tipo        = 1:
        assign de-vl-retencao = de-vl-retencao + impto-tit-pend-ap.vl-imposto.
    end. /* for each impto-tit-pend-ap ... */
              
    if  avail tit-ap then do:          
        for each  impto-tit-pend-ap use-index codigo
            where impto-tit-pend-ap.ep-codigo    = tit-ap.ep-codigo
            and   impto-tit-pend-ap.cod-estabel  = tit-ap.cod-estabel
            and   impto-tit-pend-ap.cod-esp      = tit-ap.cod-esp
            and   impto-tit-pend-ap.serie        = tit-ap.serie
            and   impto-tit-pend-ap.nr-docto     = tit-ap.nr-docto
            and   impto-tit-pend-ap.parcela      = tit-ap.parcela
            and   impto-tit-pend-ap.cod-fornec   = tit-ap.cod-fornec
            and   impto-tit-pend-ap.tipo         = 2:            
            assign de-vl-iva       = de-vl-iva       + impto-tit-pend-ap.vl-imposto
                   de-vl-percepcao = de-vl-percepcao + impto-tit-pend-ap.vl-percepcao.            
            if  impto-tit-pend-ap.lancamento = 1 then do:
                assign de-vl-ret-debito = de-vl-ret-debito - impto-tit-pend-ap.vl-retencao.
            end. /* if impto-tit-pend-ap ... */
            else do:
                assign de-vl-ret-credito = de-vl-ret-credito + impto-tit-pend-ap.vl-retencao.
            end. /* else do */   
        end. /* for each impto-tit-pend-ap ... */
    end. /* if avail tit-ap ... */
    
    assign de-vl-ret-saldo = de-vl-ret-original + de-vl-iva         + de-vl-percepcao
                           + de-vl-retencao     + de-vl-ret-credito - de-vl-ret-debito.
    
    if  de-vl-ret-saldo > lin-b-ap.vl-baixa then do:
        run utp/ut-msgs.p (input "show",
                           input 6955,
                           input "").
    end. /* if de-vl-re-saldo ... */
end. /* if avail lin-b-ap ... */    
    
/* Fim de Include */
    
