/******************************************************************************
***
*** app/ap0002.i3 - Verifica Autoriza‡äes Documento.
***
***              ### (Include usada nos programas ap0002.p e ap0002a.p) e tamb‚m
***                   pode ser utilizada diretamente criando uma PI e definindo as 
***                   variaveis abaixo.
***
******************************************************************************/

if  avail param-ap then do:
    if  param-ap.considera-niveis = yes then do:
                      
        if  l-estabelec then do:
            case p-tipo-pagto:
                 when 1 then do:
                      /*--- DOC ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 01, 02)).
                 end.
                 when 2 then do:
                      /*--- CRDITO CONTA CORRENTE ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 03, 02)).
                 end.
                 when 3 then do:
                      /*--- CHEQUE ADMINISTRATIVO ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 05, 02)).
                 end.
                 when 4 then do:
                      /*--- COBRAN€A ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 07, 02)).
                 end.
                 when 5 then do:
                      /*--- CHEQUE NOMINAL ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 09, 02)).
                 end.
                 /* apartir da versÆo 202 */
                 when 6 then do:
                      /*--- D‚bito em Conta Corrente ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 11, 02)).
                 end.
                 when 7 then do:
                      /*--- CartÆo de Cr‚dito ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 13, 02)).
                 end.
                 when 8 then do:
                      /*--- Agendamento Eletr“nico ---*/
                      assign i-nr-autoriz = int(substring(c-char-2, 15, 02)).
                 end.
            end case.
                
            if  i-nr-autoriz > 0 then do:
            
                for each  usuar-autoriza-tit
                    where usuar-autoriza-tit.ep-codigo    = p-ep-codigo
                    and   usuar-autoriza-tit.nr-bordero   = 0
                    and   usuar-autoriza-tit.cod-portador = 0
                    and   usuar-autoriza-tit.cod-estabel  = p-cod-estabel
                    and   usuar-autoriza-tit.cod-fornec   = p-cod-fornec
                    and   usuar-autoriza-tit.cod-esp      = p-cod-esp
                    and   usuar-autoriza-tit.serie        = p-serie
                    and   usuar-autoriza-tit.nr-docto     = p-nr-docto
                    and   usuar-autoriza-tit.parcela      = p-parcela
                    and   usuar-autoriza-tit.dec-1        = p-valor
                    and   usuar-autoriza-tit.int-1        = p-tipo-pagto
                    and   usuar-autoriza-tit.autorizou    = yes:
                    assign i-permissao = i-permissao + 1.
                end.
                    
                if  i-permissao < i-nr-autoriz then do:
                    if  l-view-msg = yes then do:
                        run utp/ut-msgs.p (input "show",
                                           input 15462,
                                           input string(i-nr-autoriz) + "~~" +
                                                 string(i-permissao)).
                    end.
                    assign l-erro = yes.
                end.
            end.
        end.
        else do:
            if  l-view-msg = yes then do:
                run utp/ut-msgs.p (input "show",
                                   input 777,
                                   input p-cod-estabel).
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

/* Fim de Include */
