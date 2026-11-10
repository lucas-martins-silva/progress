find first param-ap no-lock
    where param-ap.ep-codigo = i-ep-codigo-usuario no-error.

if avail param-ap then do:
    &if '{&mgadm_version}' >= '2.07' &then
        if param-ap.log-sem-desemb then
            assign c-verif-sem-desembolso = "s".
    &else
        assign c-verif-sem-desembolso = substring(param-ap.char-1,9,1).
    &endif
end.

if c-verif-sem-desembolso = "s" then do:
   for each tt-impto-tit-pend-ap-aux:
       delete tt-impto-tit-pend-ap-aux.
   end.
   for each tt-doc-b-ap:
       delete tt-doc-b-ap.
   end.
   for each tt-lin-b-ap:
       delete tt-lin-b-ap.
   end.
   for each tt-l-ant-ap:
       delete tt-l-ant-ap.
   end.
   for each tt-l-pre-ap:
       delete tt-l-pre-ap.
   end.
   for each tt-retorno-lin-b-ap:
       delete tt-retorno-lin-b-ap.
   end.

   for each tt-baixa
      where tt-baixa.atualiza = yes:

       assign v_val_tot_impto = 0.
       for each  impto-tit-pend-ap no-lock
            where impto-tit-pend-ap.ep-codigo  = i-ep-codigo-usuario
            and   impto-tit-pend-ap.cod-estab  = tt-baixa.cod-estabel
            and   impto-tit-pend-ap.cod-esp    = tt-baixa.cod-esp
            and   impto-tit-pend-ap.serie      = tt-baixa.serie
            and   impto-tit-pend-ap.nr-docto   = tt-baixa.nr-docto
            and   impto-tit-pend-ap.parcela    = tt-baixa.parcela
            and   impto-tit-pend-ap.cod-fornec = tt-baixa.cod-fornec
            &if "{&mgadm_version}" >= "2.07" &then
                and impto-tit-pend-ap.cdn-empres-pagto = i-ep-codigo-usuario
                and impto-tit-pend-ap.cod-refer-pagto  = tt-baixa.referencia
            &else
                and trim(substr(impto-tit-pend-ap.char-2,01,03)) = trim(string(i-ep-codigo-usuario))
                and trim(substr(impto-tit-pend-ap.char-2,04,10)) = trim(tt-baixa.referencia)
            &endif
            and impto-tit-pend-ap.trans-impto-ap = 2:

            find first tipo-tax no-lock
                 where tipo-tax.cod-tax = impto-tit-pend-ap.cod-imposto no-error.
            if  avail tipo-tax then do:
                if  &if '{&mgadm_version}' >= '2.06' &then
                    impto-tit-pend-ap.vl-base > tipo-tax.val-base-inicio
                    &else
                    impto-tit-pend-ap.vl-base > tipo-tax.dec-2
                    &endif
                then
                    assign v_val_tot_impto = v_val_tot_impto + impto-tit-pend-ap.vl-imposto.
            end.
       end.

       for each l-ant-ap
          where l-ant-ap.ep-codigo    = i-ep-codigo-usuario
            and l-ant-ap.cod-est-ant  = tt-baixa.cod-estabel
            and l-ant-ap.cod-esp-ant  = tt-baixa.cod-esp
            and l-ant-ap.serie-ant    = tt-baixa.serie
            and l-ant-ap.nr-docto-ant = tt-baixa.nr-docto
            and l-ant-ap.parcela-ant  = tt-baixa.parcela
            and l-ant-ap.fornec-ant   = tt-baixa.cod-fornec no-lock:
            assign c-val-tot-antecip = c-val-tot-antecip + l-ant-ap.vl-antecip.
       end.

       if (tt-baixa.valor-saldo - 
          (tt-baixa.de-vl-desconto 
          &if defined(BF_FIN_MULTA_ABATIMENTO) &then
           + tt-baixa.vl-abatimento
          &endif
          + c-val-tot-antecip) -
          v_val_tot_impto = 0) and v_val_tot_impto > 0 then do:
               
               if not l-ch-apapi003 then do:
                   do i-cont = 1 to 9999:
                       find first tt-doc-b-ap
                           where  tt-doc-b-ap.referencia = string(month(today),"99") + string(day(today)  ,"99") + substr(string(year(today),"9999"), 3,2) + STRING(i-cont) no-error.
                       if avail tt-doc-b-ap then
                           next.

                       find first lin-b-ap USE-INDEX codigo no-lock
                            where lin-b-ap.ep-codigo  = i-ep-codigo-usuario
                              and lin-b-ap.referencia = string(month(today),"99") + string(day(today)  ,"99") + substr(string(year(today),"9999"), 3,2) + STRING(i-cont) no-error.
                       if avail lin-b-ap then
                           next.

                       find first mov-ap USE-INDEX codigo no-lock
                          where mov-ap.ep-codigo   = i-ep-codigo-usuario
                            AND mov-ap.cod-fornec  = tt-baixa.cod-fornec
                            AND mov-ap.cod-estabel = tt-baixa.cod-estabel
                            and mov-ap.referencia  = string(month(today),"99") + string(day(today)  ,"99") + substr(string(year(today),"9999"), 3,2) + STRING(i-cont) no-error.
                       if avail mov-ap then
                           next.

                       assign c-seq-refer = string(month(today),"99") + string(day(today)  ,"99") + substr(string(year(today),"9999"), 3,2) + STRING(i-cont).
                       leave.
                   end.

                   assign l-ch-apapi003 = yes.

                   create tt-doc-b-ap.
                   assign tt-doc-b-ap.ep-codigo                  = tt-param-nom.ep-codigo
                          tt-doc-b-ap.referencia                 = c-seq-refer
                          tt-doc-b-ap.cod-estabel                = tt-baixa.cod-estabel
                          tt-doc-b-ap.cod-esp                    = tt-baixa.cod-esp
                          tt-doc-b-ap.data-movto                 = tt-baixa.dt-baixa
                          tt-doc-b-ap.total-movto                = 0
                          tt-doc-b-ap.mo-codigo                  = tt-baixa.moeda
                          tt-doc-b-ap.ind-sit-lote-liquidacao-ap = 1
                          tt-doc-b-ap.cod-versao-integ           = 001
                          tt-doc-b-ap.ind-elimina-lote           = 1.
               end.

               assign d-tot-movto = d-tot-movto + tt-baixa.valor-saldo.

               find last tt-lin-b-ap use-index codigo
                   where tt-lin-b-ap.ep-codigo      = tt-param-nom.ep-codigo
                     and tt-lin-b-ap.referencia     = c-seq-refer no-error.

               if avail tt-lin-b-ap then
                   assign i-cont = tt-lin-b-ap.sequencia + 10.
               else
                   assign i-cont = 10.

               create tt-lin-b-ap.
               assign tt-lin-b-ap.ep-codigo         = tt-param-nom.ep-codigo
                      tt-lin-b-ap.referencia        = c-seq-refer
                      tt-lin-b-ap.sequencia         = i-cont
                      tt-lin-b-ap.transacao         = 2
                      tt-lin-b-ap.serie             = tt-baixa.serie
                      tt-lin-b-ap.nr-docto          = tt-baixa.nr-docto
                      tt-lin-b-ap.parcela           = tt-baixa.parcela
                      tt-lin-b-ap.nr-cheque         = 0
                      tt-lin-b-ap.dt-baixa          = tt-baixa.dt-baixa
                      tt-lin-b-ap.vl-baixa          = tt-baixa.valor-saldo
                      tt-lin-b-ap.vl-desconto       = tt-baixa.de-vl-desconto
                      tt-lin-b-ap.vl-juros          = tt-baixa.de-vl-juros
                      &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                      tt-lin-b-ap.vl-abatimento    = tt-baixa.vl-abatimento
                      tt-lin-b-ap.vl-multa         = tt-baixa.vl-multa
                      tt-lin-b-ap.vl-abatimento-me = tt-baixa.vl-abatimento-me
                      tt-lin-b-ap.vl-multa-me      = tt-baixa.vl-multa-me
                      &endif                        
                      tt-lin-b-ap.portador         = tt-baixa.portador
                      tt-lin-b-ap.int-2            = 1
                      tt-lin-b-ap.cod-esp          = tt-baixa.cod-esp
                      tt-lin-b-ap.cod-estabel      = tt-baixa.cod-estabel
                      tt-lin-b-ap.cod-fornec       = tt-baixa.cod-fornec
                      tt-lin-b-ap.origem           = 1
                      tt-lin-b-ap.cotacao-dia      = 1
                      tt-lin-b-ap.dt-vencimen      = tt-baixa.dt-vencimen
                      tt-lin-b-ap.mo-codigo        = 0
                      tt-lin-b-ap.estado           = 1
                      tt-lin-b-ap.vl-baixa-me      = tt-baixa.vl-saldo-me
                      tt-lin-b-ap.vl-desconto-me   = tt-baixa.de-vl-desconto-me
                      tt-lin-b-ap.vl-juros-me      = tt-baixa.de-vl-juros-me
                      tt-lin-b-ap.ind-liberado-pag = yes.

               for each impto-tit-pend-ap exclusive-lock
                  where impto-tit-pend-ap.ep-codigo  = i-ep-codigo-usuario
                    and impto-tit-pend-ap.cod-estab  = tt-baixa.cod-estabel
                    and impto-tit-pend-ap.cod-esp    = tt-baixa.cod-esp
                    and impto-tit-pend-ap.serie      = tt-baixa.serie
                    and impto-tit-pend-ap.nr-docto   = tt-baixa.nr-docto
                    and impto-tit-pend-ap.parcela    = tt-baixa.parcela
                    and impto-tit-pend-ap.cod-fornec = tt-baixa.cod-fornec:

                   &if "{&mgadm_version}" >= "2.07" &then
                       assign impto-tit-pend-ap.cod-refer-pagto = tt-lin-b-ap.referencia
                              impto-tit-pend-ap.num-seq-pagto   = tt-lin-b-ap.sequencia.
                   &else
                       assign substring(impto-tit-pend-ap.char-2,04,10) = string(tt-lin-b-ap.referencia)
                              substring(impto-tit-pend-ap.char-2,14,06) = string(tt-lin-b-ap.sequencia).
                   &endif
               end.

               for each lin-b-ap exclusive-lock
                   where lin-b-ap.ep-codigo   = tt-param-nom.ep-codigo
                     and lin-b-ap.cod-fornec  = tt-baixa.cod-fornec
                     and lin-b-ap.cod-estabel = tt-baixa.cod-estabel
                     and lin-b-ap.cod-esp     = tt-baixa.cod-esp
                     and lin-b-ap.serie       = tt-baixa.serie
                     and lin-b-ap.nr-docto    = tt-baixa.nr-docto
                     and lin-b-ap.parcela     = tt-baixa.parcela
                     and lin-b-ap.referencia  = tt-baixa.referencia:
                   delete lin-b-ap.
               end.

               delete tt-baixa.
       end.
   end.
   if l-ch-apapi003 then do:

       find first tt-doc-b-ap no-error.
       if avail tt-doc-b-ap then
           assign tt-doc-b-ap.total-movto = d-tot-movto.

       run app/apapi003a.p (input  table tt-doc-b-ap,
                            input  table tt-lin-b-ap,
                            input  table tt-l-ant-ap,
                            input  table tt-l-pre-ap,
                            input  table tt-impto-tit-pend-ap-aux,
                            output table tt-retorno-lin-b-ap).
   end.
end.
