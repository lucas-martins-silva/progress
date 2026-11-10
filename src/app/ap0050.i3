/******************************************************************************
***
*** app/ap0050.i3 - Verifica Autorizaá‰es Documento.
***
***              ### (Include usada no programa ap0050.p) e tambÇm
***                   pode ser utilizada diretamente criando uma PI e definindo as 
***                   variaveis abaixo.
***
******************************************************************************/

    if  avail param-ap then do:
        if  param-ap.considera-niveis = yes then do:
            if  l-estabelec then do:
                case tit-ap.tp-pagto:
                     when 1 then do:
                          /*--- DOC ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 01, 02)).
                     end.
                     when 2 then do:
                          /*--- CRêDITO CONTA CORRENTE ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 03, 02)).
                     end.
                     when 3 then do:
                          /*--- CHEQUE ADMINISTRATIVO ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 05, 02)).
                     end.
                     when 4 then do:
                          /*--- COBRANÄA ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 07, 02)).
                     end.
                     when 5 then do:
                          /*--- CHEQUE NOMINAL ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 09, 02)).
                     end.
                     /* apartir da vers∆o 202 */
                     when 6 then do:
                          /*--- DÇbito em Conta Corrente ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 11, 02)).
                     end.
                     when 7 then do:
                          /*--- Cart∆o de CrÇdito ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 13, 02)).
                     end.
                     when 8 then do:
                          /*--- Agendamento Eletrìnico ---*/
                          assign i-nr-autoriz = int(substring(c-char-2, 15, 02)).
                     end.
                end case.
                for each  usuar-autoriza-tit no-lock
                    where usuar-autoriza-tit.ep-codigo    = tit-ap.ep-codigo
                    and   usuar-autoriza-tit.nr-bordero   = 0
                    and   usuar-autoriza-tit.cod-portador = 0
                    and   usuar-autoriza-tit.cod-estabel  = tit-ap.cod-estabel
                    and   usuar-autoriza-tit.cod-fornec   = tit-ap.cod-fornec
                    and   usuar-autoriza-tit.cod-esp      = tit-ap.cod-esp
                    and   usuar-autoriza-tit.serie        = tit-ap.serie
                    and   usuar-autoriza-tit.nr-docto     = tit-ap.nr-docto
                    and   usuar-autoriza-tit.parcela      = tit-ap.parcela
                    and   usuar-autoriza-tit.int-1        = tit-ap.tp-pagto
                    and   usuar-autoriza-tit.autorizou    = yes
                    &if defined(BF_FIN_AUT_PEF) &then
                        and usuar-autoriza-tit.referencia = tit-ap.referencia
                    &else
                        and entry(1,usuar-autoriza-tit.char-2,chr(10)) = tit-ap.referencia
                    &endif
                    :
                    assign i-permissao = i-permissao + 1.
                end.
                
                if  i-permissao < i-nr-autoriz then do:
                    if  l-view-msg = yes then do:
                        {utp/ut-liter.i Documento}
                        assign c-tipo = trim(return-value).
                        
                        if  tit-ap.tipo = 2 then do:
                            {utp/ut-liter.i Antecipaá∆o}
                            assign c-tipo = trim(return-value).
                        end.
                        run utp/ut-msgs.p (input "show",
                                           input 15462,
                                           input string(i-nr-autoriz) + "~~" +
                                                 string(i-permissao) + "~~" +
                                                 trim(c-tipo)).
                    end.
                    assign l-erro = yes.
                end.
            end.
            else do:
                if  l-view-msg = yes then do:
                    run utp/ut-msgs.p (input "show",
                                       input 777,
                                       input tit-ap.cod-estabel).
                end.
                assign l-erro = yes.
            end.
        end.
    end.
    else do:
        if  l-view-msg = yes then do:
            run utp/ut-msgs.p (input "show",
                               input 28,
                               input "").
        end.
        assign l-erro = yes.
    end.
