/***********************************************************************
**                                                                    **
**   AP0501C.I3 - Rateio dos valores qdo usa mais de uma conta        **
**                                                                    **
***********************************************************************/                  
        
    assign de-total-docto = impto-tit-pend-ap.vl-imposto.     

    for each lin-conta-ap
       where lin-conta-ap.ep-codigo   = lin-i-ap.ep-codigo
         and lin-conta-ap.cod-estabel = lin-i-ap.cod-estabel    
         and lin-conta-ap.cod-esp     = lin-i-ap.cod-esp
         and lin-conta-ap.serie       = lin-i-ap.serie
         and lin-conta-ap.nr-docto    = lin-i-ap.nr-docto
         and lin-conta-ap.parcela     = lin-i-ap.parcela
         and lin-conta-ap.cod-fornec  = lin-i-ap.cod-fornec
         exclusive-lock break by lin-conta-ap.ep-codigo:
        
        create b-lin-conta-ap.    
        assign b-lin-conta-ap.ep-codigo    = lin-i-ap.ep-codigo
               b-lin-conta-ap.cod-estabel  = impto-tit-pend-ap.cod-estabel
               b-lin-conta-ap.cod-esp      = impto-tit-pend-ap.cod-esp
               b-lin-conta-ap.serie        = impto-tit-pend-ap.serie
               b-lin-conta-ap.nr-docto     = impto-tit-pend-ap.nr-docto
               b-lin-conta-ap.parcela      = impto-tit-pend-ap.parcela
               b-lin-conta-ap.cod-fornec   = impto-tit-pend-ap.cod-fornec
               b-lin-conta-ap.conta-debito = impto-tit-pend-ap.conta-imposto
               b-lin-conta-ap.ct-codigo    = lin-conta-ap.ct-codigo
               b-lin-conta-ap.sc-codigo    = lin-conta-ap.sc-codigo
               b-lin-conta-ap.conta-debito = lin-conta-ap.conta-debito.
               
        assign b-lin-conta-ap.vl-movto     = fn_ajust_dec((lin-conta-ap.vl-movto
                                           / b-lin-i-ap.vl-original
                                           * impto-tit-pend-ap.vl-imposto),b-lin-conta-ap.mo-codigo).
        assign de-total-docto              = de-total-docto 
                                           - b-lin-conta-ap.vl-movto.

        if  last-of(lin-conta-ap.ep-codigo)
        and de-total-docto <> 0 then
            assign b-lin-conta-ap.vl-movto = b-lin-conta-ap.vl-movto
                                           + de-total-docto.
        if  l-desconta then 
            assign lin-conta-ap.vl-movto  = lin-conta-ap.vl-movto
                                          - b-lin-conta-ap.vl-movto.
    end.

     

/* Fim do ap0501c.i3*/
