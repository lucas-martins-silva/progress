/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

for each  mov-ap
    where mov-ap.ep-codigo    = tt-param.i-empresa
    {1}
    {2}
    and   mov-ap.portador     = tt-param.i-portador
    and   mov-ap.cod-estabel >= tt-param.c-est-ini
    and   mov-ap.cod-estabel <= tt-param.c-est-fim
    and   mov-ap.cod-esp     >= tt-param.c-esp-ini
    and   mov-ap.cod-esp     <= tt-param.c-esp-fim
    and   mov-ap.nr-docto    >= tt-param.i-docto-ini
    and   mov-ap.nr-docto    <= tt-param.i-docto-fim
    and   mov-ap.cod-fornec  >= tt-param.i-fornec-ini
    and   mov-ap.cod-fornec  <= tt-param.i-fornec-fim
    and   mov-ap.emit-fita    = no   
    and   mov-ap.dt-vencimen >= tt-param.da-vencimen-ini
    and   mov-ap.dt-vencimen <= tt-param.da-vencimen-fim
    no-lock
    break by mov-ap.ep-codigo
          by mov-ap.dt-transacao:

    /*--- PAG - Envio de Pagamento ---*/
    if    tt-param.i-oco = 1 then do:
          if mov-ap.transacao <> 1 and
             mov-ap.transacao <> 6 then
             next.
          if mov-ap.transacao  = 6 and
             mov-ap.lancamento = 1 then
             next.
    end.
    else do:
          /*--- OCO - Ocorrància de Pagamento ---*/
          if mov-ap.transacao <> 13 and
             mov-ap.transacao <> 14 and
             mov-ap.transacao <> 15 and
             mov-ap.transacao <> 11 and
             mov-ap.transacao <> 12 and
             mov-ap.transacao <> 10 and
             mov-ap.transacao <> 5  then
             next.
    end.


    find tit-ap of mov-ap no-lock no-error.

    if  avail tit-ap then do:

        if tt-param.i-oco = 1 then
           if tit-ap.nr-bordero > 0 then
              next.  

           if  tit-ap.moeda <> 0 then
               next.

           if  tit-ap.estado <> 1 and tt-param.l-estado = no then
               next.

           if (tit-ap.valor-saldo = 0 
           and mov-ap.transacao <> 10) 
           or  tit-ap.tipo      <> 1 then
               next.

           if  tt-param.i-oco <> 2 then do:
               if  tit-ap.enviado = yes and tit-ap.titulo-banco <> "" then
                   next.
    end.

        /******** EPC Grendene ****************/
        assign l-libera = yes.
        if  tit-ap.origem = 2 then do:
            for each tt-epc where 
                     tt-epc.cod-event = "VERIFICA_DIVERG"
                     exclusive-lock:
                delete tt-epc.
            end.    
            create tt-epc.
            assign tt-epc.cod-event     = "VERIFICA_DIVERG"
                   tt-epc.cod-parameter = "DOCUMENT"
                   tt-epc.val-parameter = tit-ap.nr-docto           + ","
                                        + tit-ap.serie              + ","
                                        + tit-ap.cod-estabel        + ","
                                        + string(tit-ap.cod-fornec) + ","
                                        + tit-ap.cod-esp            + ","
                                        + tit-ap.parcela            + ","
                                        + string(tit-ap.ep-codigo).
                  {include/i-epc201.i "VERIFICA_DIVERG"}

            find first tt-epc 
                where tt-epc.cod-event     = "VERIFICA_DIVERG" and
                      tt-epc.cod-parameter = "RETURN" no-error.                             
            if  avail tt-epc
            and entry(1,tt-epc.val-parameter,",") = "no" then do: /* n∆o liberado pelo recebimento */
                assign l-libera = no.
            end.
            if  l-libera = no then
                next.
        end.
        /**************************************/


        find first tt-emitente 
             where tt-emitente.cod-emit   = mov-ap.cod-fornec 
             and   tt-emitente.identific <> 1 no-lock no-error.
        if  not avail tt-emitente then do:
            find first emitente 
                 where emitente.cod-emitente = mov-ap.cod-fornec 
                 and   emitente.identific   <> 1 no-lock no-error.
            if  not avail emitente then
                next.
            create tt-emitente.
            buffer-copy emitente to tt-emitente.    
        end.

        find first tt-portador no-lock 
             where tt-portador.ep-codigo    = mov-ap.ep-codigo
             and   tt-portador.cod-portador = mov-ap.portador
             and   tt-portador.modalidade   = 1 no-error.
        if  not avail tt-portador then do: 
            find first portador no-lock
                 where portador.ep-codigo    = mov-ap.ep-codigo
                 and   portador.cod-portador = mov-ap.portador
                 and   portador.modalidade   = 1 no-error.

            if  not avail portador then
                next.

            create tt-portador.
            buffer-copy portador to tt-portador.    
        end.

        if  tt-portador.log-2 = no then /* N∆o envia documentos atrasados */
            /*--- Prazo de envio ---*/
            if (tit-ap.dt-vencimen - today) < 0 then
                next.

        &if "{&mgadm_version}" >= "2.02" &then 
            if l-valid-tp-pagto = yes then do:
                if  (tit-ap.tp-pagto = 5 or 
                     tit-ap.tp-pagto = 6 or 
                     tit-ap.tp-pagto = 7 ) then 
                     next.
            end.
        &endif.            

        assign l-erro = no.
        run pi-autorizacoes.  /* antiga chamada do ap0001a.p */                   
        if  l-erro = yes then
            next.

        run pi-criar-tt-tit-ap.
    end.
end.
