/*******************************************************************************
**
**  AP5515.i - Atualizacao.
**
*******************************************************************************/
{utp/ut-liter.i Atualizando_Documentos}.
STATUS INPUT trim(return-value) + "..." .
find param-fasb where param-fasb.ep-codigo = i-ep-codigo-usuario no-lock no-error.
find param-ap where param-ap.ep-codigo = i-ep-codigo-usuario no-lock no-error.
assign i-dia-ir = param-ap.prazo-pagto-ir.
find portador where portador.ep-codigo  = i-ep-codigo-usuario
                and portador.cod-port   = i-portador
                and portador.modalidade = 1 no-lock no-error.

Bordero:
for each bordero-ap where bordero-ap.ep-codigo  = i-ep-codigo-usuario
                      and bordero-ap.nr-bordero = i-bordero
                      and bordero-ap.emitiu     = no :

    find bord-ap of bordero-ap no-lock no-error.
    find espec-ap where espec-ap.cod-esp = bordero-ap.cod-esp no-lock no-error.
    
    
    if bordero-ap.transacao = 1 /*IMD*/ then do:
        find emitente where emitente.cod-emit = bordero-ap.cod-fornec
                        and emitente.identific <> 1 no-lock no-error.
        
        create tit-ap.
        assign tit-ap.ep-codigo    = bordero-ap.ep-codigo
               tit-ap.referencia   = bordero-ap.referencia
               tit-ap.cod-esp      = bordero-ap.cod-esp
               tit-ap.cod-estabel  = bordero-ap.cod-estabel
               tit-ap.serie        = bordero-ap.serie
               tit-ap.nr-docto     = bordero-ap.nr-docto
               tit-ap.parcela      = bordero-ap.parcela
               tit-ap.cod-fornec   = bordero-ap.cod-fornec
               tit-ap.transacao    = 1 /*IMD*/
               tit-ap.tipo         = 2 /*AN*/
               tit-ap.dt-emissao   = bord-ap.dt-emissao when avail bord-ap
               tit-ap.dt-vencimen  = bordero-ap.dt-vencto
               tit-ap.ct-conta-db  = bordero-ap.ct-codigo
               tit-ap.sc-conta-db  = bordero-ap.sc-codigo
               tit-ap.vl-original  = bordero-ap.vl-docto
               tit-ap.nr-cheque    = 0
               tit-ap.portador     = bordero-ap.portador
               tit-ap.pedido       = &if "{&mgdis_version}" >= "2.02" &then
                                         bordero-ap.titulo-banco
                                     &else
                                         bordero-ap.pedido
                                     &endif
               tit-ap.valor-saldo  = tit-ap.vl-original
               tit-ap.dt-transacao = tit-ap.dt-emissao
               tit-ap.dt-prev-pag  = tit-ap.dt-emissao
               tit-ap.dt-fluxo     = tit-ap.dt-vencimen
               tit-ap.nr-bordero   = bordero-ap.nr-bordero
               tit-ap.tp-codigo    = bordero-ap.tp-codigo.

        if available emitente then
           assign tit-ap.nome-abrev   = emitente.nome-abrev.
        else  assign tit-ap.nome-abrev   = "".

        find b-emitente where b-emitente.nome-abrev = emitente.nome-matriz no-lock no-error.
        if  avail b-emitente then
            assign tit-ap.matriz = b-emitente.cod-emit.

        create mov-ap.
        assign mov-ap.ep-codigo      = tit-ap.ep-codigo
               mov-ap.cod-estabel    = tit-ap.cod-estabel
               mov-ap.cod-esp        = tit-ap.cod-esp
               mov-ap.serie          = tit-ap.serie
               mov-ap.nr-docto       = tit-ap.nr-docto
               mov-ap.parcela        = tit-ap.parcela
               mov-ap.nome-abrev     = tit-ap.nome-abrev
               mov-ap.historico      = bordero-ap.historico
               mov-ap.cod-fornec     = tit-ap.cod-fornec
               mov-ap.dt-emissao     = tit-ap.dt-emissao
               mov-ap.dt-transacao   = tit-ap.dt-emissao
               mov-ap.dt-vencimen    = tit-ap.dt-vencimen
               mov-ap.referencia     = tit-ap.referencia
               mov-ap.nr-cheque      = tit-ap.nr-cheque
               mov-ap.valor-mov      = bordero-ap.vl-docto
               mov-ap.portador       = tit-ap.portador

            &if "{&mgdis_version}" >= "2.02" &then
               mov-ap.titulo-banco   = tit-ap.pedido
            &else
               mov-ap.pedido         = tit-ap.pedido
            &endif

               mov-ap.transacao      = 1 /*IMD*/
               mov-ap.nr-docto-emp   = string(tit-ap.nr-bordero)
               mov-ap.nr-bordero     = tit-ap.nr-bordero
               mov-ap.ct-conta       = tit-ap.ct-conta-db
               mov-ap.sc-conta       = tit-ap.sc-conta-db
               mov-ap.tp-codigo      = bordero-ap.tp-codigo
               mov-ap.dt-today       = today
               mov-ap.c-time         = string(time, "HH:MM")
               mov-ap.usuario        = c-seg-usuario.
      
        find first usuar-autoriza-tit where 
                        usuar-autoriza-tit.ep-codigo = mov-ap.ep-codigo
                   and  usuar-autoriza-tit.cod-estabel = mov-ap.cod-estabel
                   and  usuar-autoriza-tit.cod-esp = mov-ap.cod-esp
                   and  usuar-autoriza-tit.serie = mov-ap.serie
                   and  usuar-autoriza-tit.nr-docto = mov-ap.nr-docto
                   and  usuar-autoriza-tit.parcela = mov-ap.parcela
                   and  usuar-autoriza-tit.cod-fornec = mov-ap.cod-fornec no-error. 
        if avail usuar-autoriza-tit then
          assign usuar-autoriza-tit.char-1 = string(rowid(mov-ap)).         

        
      /*  Atualizacao de informacoes para FASB e CMI   */
         /*-------- INTEGRA€åES INCLUSÇO ---------*/
       {app/ap9100.i2}
        assign  tt-integ-ap.tt-row-tit-ap  = rowid(tit-ap)
                tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
                tt-integ-ap.tt-fc1014a     = yes
                tt-integ-ap.tt-fc1114a     = yes
                tt-integ-ap.tt-cb0201a     = yes
                tt-integ-ap.tt-cb1202a     = yes
                tt-integ-ap.tt-ge0102b     = yes
                tt-integ-ap.tt-ge0102g     = yes
                tt-integ-ap.tt-op-cb0201a  = 16
                tt-integ-ap.tt-op-cb1202a  = 16
                tt-integ-ap.tt-op-ge0102b  = 16
                tt-integ-ap.tt-op-ge0102g  = 16.

        raw-transfer tt-integ-ap to raw-integracao.
        run app/ap9100.p (Input raw-integracao,
                          input-output table tt-erro).                    
            
        /* Atualizacao de Imposto de Renda */

        find first b-bordero-ap
            where b-bordero-ap.ep-codigo  = bordero-ap.ep-codigo
            and   b-bordero-ap.cod-estab  = bordero-ap.cod-estab
            and   b-bordero-ap.cod-fornec = bordero-ap.cod-fornec
            and   b-bordero-ap.serie-ir   = bordero-ap.serie
            and   b-bordero-ap.esp-ir     = bordero-ap.cod-esp
            and   b-bordero-ap.docto-ir   = bordero-ap.nr-docto
            and   b-bordero-ap.parc-ir    = bordero-ap.parcela
            exclusive-lock no-error.
        if  avail b-bordero-ap then do:
            if  tit-ap.dt-emissao < 01/01/1995 then do:
                if  day(tit-ap.dt-emissao) <= 15 then
                    assign da-vencto-ir =  date(month(tit-ap.dt-emissao),
                                           15, year(tit-ap.dt-emissao)).
                                           
            else
               if  month(tit-ap.dt-emissao) < 12 then
                    assign da-vencto-ir =  date(integer(month(tit-ap.dt-emissao)
                                           + 1), 01, year(tit-ap.dt-emissao)) - 1.
               else
                    assign da-vencto-ir = date(01,01,int(year(tit-ap.dt-emissao)
                                          + 1)) - 1.
                 
                do  i-cont2 = 1 to i-dia-ir:
                    find first calen-coml
                        where calen-coml.ep-codigo    = tit-ap.ep-codigo
                        and   calen-coml.cod-estabel  = tit-ap.cod-estab
                        and   calen-coml.data         > da-vencto-ir            
                        and   calen-coml.tipo-dia     = 1
                        no-lock no-error.
                    if  avail calen-coml then
                        assign da-vencto-ir = calen-coml.data.
                    else do:
                        run utp/ut-msgs.p (input "show",
                                           input 378,
                                           input da-vencto-ir).
                        assign da-vencto-ir = da-vencto-ir + 1.
                    end.
                end.
            end.
            else do:
                assign da-vencto = tit-ap.dt-vencimen.
                do  i-cont1 = 1 to 7:
                    assign i-dia = weekday(da-vencto).
                    if  i-dia = 1 then
                        leave.
                    assign da-vencto = da-vencto + 1.
                end.
                assign i-dias = 0.
                repeat:
                    assign da-vencto = da-vencto + 1.
                    find calen-coml
                        where calen-coml.ep-codigo   = tit-ap.ep-codigo         
                        and   calen-coml.cod-estabel = tit-ap.cod-estab
                        and   calen-coml.data        = da-vencto
                        no-lock no-error.
                    if  not avail calen-coml then do:
                        run utp/ut-msgs.p (input "show",
                                           input 378,
                                           input da-vencto-ir).          
                    end.
                    if  calen-coml.tipo = 1 then
                        assign i-dias  = i-dias + 1.
                    if  i-dias = i-dia-ir then
                        leave.
                end.
                assign da-vencto-ir = da-vencto.
            end.
            create b-tit-ap.
            assign b-tit-ap.ep-codigo    = b-bordero-ap.ep-codigo
                   b-tit-ap.referencia   = b-bordero-ap.referencia
                   b-tit-ap.cod-esp      = b-bordero-ap.cod-esp
                   b-tit-ap.cod-estabel  = b-bordero-ap.cod-estabel
                   b-tit-ap.serie        = b-bordero-ap.serie
                   b-tit-ap.nr-docto     = b-bordero-ap.nr-docto
                   b-tit-ap.parcela      = b-bordero-ap.parcela
                   b-tit-ap.cod-fornec   = b-bordero-ap.cod-fornec
                   b-tit-ap.nome-abrev   = emitente.nome-abrev
                   b-tit-ap.transacao    = 1 /*imd*/
                   b-tit-ap.tipo         = 8 /*"IR"*/
                   b-tit-ap.dt-emissao   = bord-ap.dt-emissao when avail bord-ap
                   b-tit-ap.dt-vencimen  = da-vencto-ir
                   b-tit-ap.dt-prev-pag  = b-tit-ap.dt-vencimen
                   b-tit-ap.dt-fluxo     = b-tit-ap.dt-vencimen
                   b-tit-ap.ct-conta-db  = b-bordero-ap.ct-codigo
                   b-tit-ap.sc-conta-db  = b-bordero-ap.sc-codigo
                   b-tit-ap.vl-original  = b-bordero-ap.vl-docto
                   b-tit-ap.nr-cheque    = 0
                   b-tit-ap.portador     = b-bordero-ap.portador
                   b-tit-ap.pedido       = &if "{&mgdis_version}" >= "2.02" &then
                                               b-bordero-ap.titulo-banco
                                           &else
                                               b-bordero-ap.pedido
                                           &endif
                   b-tit-ap.valor-saldo  = b-tit-ap.vl-original
                   b-tit-ap.dt-transacao = b-tit-ap.dt-emissao
                   b-tit-ap.nr-bordero   = 0
                   b-tit-ap.matriz       = tit-ap.matriz
                   b-tit-ap.tp-codigo    = b-bordero-ap.tp-codigo
                   b-tit-ap.cod-retencao = b-bordero-ap.cod-ret
                   b-tit-ap.serie-ant    = tit-ap.serie
                   b-tit-ap.esp-ant      = tit-ap.cod-esp
                   b-tit-ap.docto-ant    = tit-ap.nr-docto
                   b-tit-ap.parc-ant     = tit-ap.parcela
                   b-tit-ap.valor-ir     = tit-ap.vl-original 
                                         + b-tit-ap.vl-original
                   b-tit-ap.ir-antec     = yes.    /* Indica que eh uma 
                                                   antecipacao de IR */
            assign tit-ap.esp-ant     = b-tit-ap.cod-esp
                   tit-ap.serie-ant   = b-tit-ap.serie
                   tit-ap.docto-ant   = b-tit-ap.nr-docto
                   tit-ap.parc-ant    = b-tit-ap.parcela
                   tit-ap.vl-ir-antec = b-tit-ap.vl-original
                   tit-ap.valor-ir    = b-tit-ap.valor-ir.
            create b-mov-ap.
            assign b-mov-ap.ep-codigo      = b-tit-ap.ep-codigo
                   b-mov-ap.cod-estabel    = b-tit-ap.cod-estabel
                   b-mov-ap.cod-esp        = b-tit-ap.cod-esp
                   b-mov-ap.serie          = b-tit-ap.serie
                   b-mov-ap.nr-docto       = b-tit-ap.nr-docto
                   b-mov-ap.parcela        = b-tit-ap.parcela
                   b-mov-ap.nome-abrev     = b-tit-ap.nome-abrev
                   b-mov-ap.historico      = b-bordero-ap.historico
                   b-mov-ap.cod-fornec     = b-tit-ap.cod-fornec
                   b-mov-ap.dt-emissao     = b-tit-ap.dt-emissao
                   b-mov-ap.dt-transacao   = b-tit-ap.dt-emissao
                   b-mov-ap.dt-vencimen    = b-tit-ap.dt-vencimen
                   b-mov-ap.referencia     = b-tit-ap.referencia
                   b-mov-ap.nr-cheque      = b-tit-ap.nr-cheque
                   b-mov-ap.valor-mov      = b-bordero-ap.vl-docto
                   b-mov-ap.portador       = b-tit-ap.portador

            &if "{&mgdis_version}" >= "2.02" &then
                   b-mov-ap.titulo-banco   = b-tit-ap.pedido
            &else
                   b-mov-ap.pedido         = b-tit-ap.pedido
            &endif

                   b-mov-ap.transacao      = 1  /*IMD*/
                   b-mov-ap.nr-docto-emp   = string(b-tit-ap.nr-bordero)
                   b-mov-ap.nr-bordero     = b-tit-ap.nr-bordero
                   b-mov-ap.ct-conta       = b-tit-ap.ct-conta-db
                   b-mov-ap.sc-conta       = b-tit-ap.sc-conta-db
                   b-mov-ap.serie-ant      = b-tit-ap.serie-ant
                   b-mov-ap.esp-ant        = b-tit-ap.esp-ant
                   b-mov-ap.docto-ant      = b-tit-ap.docto-ant
                   b-mov-ap.parc-ant       = b-tit-ap.parc-ant
                   b-mov-ap.tp-codigo      = b-bordero-ap.tp-codigo
                   b-mov-ap.fornec-ant     = b-tit-ap.cod-fornec.

            /*  Atualizacao de informacoes para FASB e CMI   */
            /*-------- INTEGRA€åES INCLUSÇO ---------*/
           {app/ap9100.i2}
            assign  tt-integ-ap.tt-row-tit-ap  = rowid(tit-ap)
                    tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
                    tt-integ-ap.tt-fc1014a     = yes
                    tt-integ-ap.tt-fc1114a     = yes
                    tt-integ-ap.tt-cb0201a     = yes
                    tt-integ-ap.tt-cb1202a     = yes
                    tt-integ-ap.tt-ge0102b     = yes
                    tt-integ-ap.tt-op-cb0201a  = 16
                    tt-integ-ap.tt-op-cb1202a  = 16
                    tt-integ-ap.tt-op-ge0102b  = 16.

            raw-transfer tt-integ-ap to raw-integracao.
            run app/ap9100.p (Input raw-integracao,
                              input-output table tt-erro).                    
            
            delete b-bordero-ap.
        end.
       
    end.
    else do:

       {app/ap5515.i1}
    end.       
    
    delete bordero-ap.
end.


STATUS default.
