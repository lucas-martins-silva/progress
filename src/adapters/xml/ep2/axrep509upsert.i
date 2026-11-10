/* Roman-faturam */
if  not valid-handle(h-bodi509) 
or  h-bodi509:type <> "PROCEDURE":U 
or  h-bodi509:file-name <> "dibo/bodi509.p":U then run dibo/bodi509.p persistent set h-bodi509.

/* Item-roman-faturam */
if  not valid-handle(h-bodi510) 
or  h-bodi510:type <> "PROCEDURE":U 
or  h-bodi510:file-name <> "dibo/bodi510.p":U then run dibo/bodi510.p persistent set h-bodi510.

/* Item-depos-roman */
if  not valid-handle(h-bodi511) 
or  h-bodi511:type <> "PROCEDURE":U 
or  h-bodi511:file-name <> "dibo/bodi511.p":U then run dibo/bodi511.p persistent set h-bodi511.

run openQueryStatic in h-bodi509 (input "Main":U) no-error.
if return-value = 'NOK' then run emptyRowErrors  in h-bodi509.

run goToKey         in h-bodi509 (input tt-roman-faturam.num-romaneio).
run setRecord       in h-bodi509 (input table tt-roman-faturam).

IF NOT CAN-FIND (FIRST roman-faturam WHERE  
                       roman-faturam.num-romaneio  = tt-roman-faturam.num-romaneio) THEN
ASSIGN cTranAction = "add".

CASE cTranAction:
    WHEN "add" THEN DO:
        
        run validaXMLRomaneio in h-bodi509 (input tt-roman-faturam.num-romaneio,
                                            input tt-roman-faturam.nome-abrev,
                                            input tt-roman-faturam.nr-pedcli,
                                            input cTranAction, 
                                            input tt-roman-faturam.idi-tip-roman).
        IF  RETURN-VALUE <> 'NOK' THEN DO:
            if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ then do:
                run piValidaDev-estabel in h-bodi509 (input tt-roman-faturam.cod-estabel).
            end. /* if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */  */
    
            run createRecord in h-bodi509.
        END.
        run getRowErrors in h-bodi509 (output table RowErrors).
        
        IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
            for each tt-item-roman-faturam:
                run openQueryStatic in h-bodi510 (input "Main":U) no-error.
                if return-value = 'NOK' then run emptyRowErrors  in h-bodi510.
                
                run goToKey         in h-bodi510 (input tt-item-roman-faturam.num-romaneio, input tt-item-roman-faturam.nr-sequencia).
                run validaXMLRomaneioItem in h-bodi510 (input tt-item-roman-faturam.num-romaneio,
                                                        input tt-item-roman-faturam.it-codigo,
                                                        input tt-item-roman-faturam.cod-refer,
                                                        input tt-item-roman-faturam.cod-unid-item-roman[1],
                                                        input tt-item-roman-faturam.cod-unid-item-roman[2],
                                                        input tt-item-roman-faturam.nr-seq-ped,
                                                        input tt-item-roman-faturam.qtd-romaneio[1],
                                                        input tt-item-roman-faturam.qtd-romaneio[2],
                                                        input tt-roman-faturam.nr-pedcli,
                                                        input tt-roman-faturam.nome-abrev,
                                                        input tt-roman-faturam.idi-tip-roman).

                if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ then do:
                    &if '{&BF_DIS_VERSAO_EMS}' < '2.08' &then
                        run piValidaDev in h-bodi510 (input substring(tt-item-roman-faturam.cod-livre-2,1,3),
                                                      input substring(tt-item-roman-faturam.cod-livre-2,4,16),
                                                      input tt-roman-faturam.nome-abrev,
                                                      input tt-item-roman-faturam.it-codigo,
                                                      input tt-item-roman-faturam.cod-refer,
                                                      input tt-item-roman-faturam.nr-seq-ped,
                                                      input substring(tt-item-roman-faturam.cod-livre-2,20,6),
                                                      input tt-item-roman-faturam.qtd-romaneio[1]).
                    &else
                        run piValidaDev in h-bodi510 (input tt-item-roman-faturam.cod-ser-docto-orig,
                                                      input tt-item-roman-faturam.cod-docto-orig,
                                                      input tt-roman-faturam.nome-abrev,
                                                      input tt-item-roman-faturam.it-codigo,
                                                      input tt-item-roman-faturam.cod-refer,
                                                      input tt-item-roman-faturam.nr-seq-ped,
                                                      input tt-item-roman-faturam.cod-natur-operac-orig,
                                                      input tt-item-roman-faturam.qtd-romaneio[1]).
                    &endif
                end. /* if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ */
                
                run getRowErrors    in h-bodi510 (output table RowErrors).

                IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
                    run setRecord       in h-bodi510 (input table tt-item-roman-faturam).
                    run createRecord    in h-bodi510.
                    run getRowErrors    in h-bodi510 (output table RowErrors).

                    IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
                        for each  tt-item-depos-roman 
                            where tt-item-depos-roman.num-romaneio = tt-item-roman-faturam.num-romaneio
                            and   tt-item-depos-roman.nr-sequencia = tt-item-roman-faturam.nr-sequencia
                            and   tt-item-depos-roman.it-codigo    = tt-item-roman-faturam.it-codigo
                            and   tt-item-depos-roman.cod-refer    = tt-item-roman-faturam.cod-refer:
                            run openQueryStatic        in h-bodi511 (input "Main":U) no-error.
                            if return-value = 'NOK' then run emptyRowErrors  in h-bodi511.
                            
                            run goToKey in h-bodi511 (input tt-item-depos-roman.num-romaneio,               
                                                      input tt-item-depos-roman.nr-sequencia,
                                                      input tt-item-depos-roman.it-codigo,
                                                      input tt-item-depos-roman.cod-refer,
                                                      input tt-item-depos-roman.cod-depos,
                                                      input tt-item-depos-roman.cod-localiz,
                                                      input tt-item-depos-roman.nr-serlote).
                            run validaXMLRomaneioDepos in h-bodi511 (input tt-item-depos-roman.cod-depos).

                            if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ then do:
                                run piValidaDev in h-bodi511 (input tt-item-depos-roman.cod-depos,
                                                              input tt-roman-faturam.cod-estabel,
                                                              input tt-item-depos-roman.cod-localiz,
                                                              input tt-item-depos-roman.nr-serlote,
                                                              input tt-item-depos-roman.it-codigo,
                                                              input tt-item-depos-roman.cod-refer,
                                                              input tt-item-roman-faturam.qtd-romaneio[1]).
                            end. /* if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ */
                            run getRowErrors           in h-bodi511 (output table RowErrors).
                            
                            IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
                                run setRecord    in h-bodi511 (input table tt-item-depos-roman).
                                run createRecord in h-bodi511.
                                run getRowErrors in h-bodi511 (output table RowErrors).
                            END. /* IF  NOT CAN-FIND(FIRST RowErrors) THEN DO: */
                            delete tt-item-depos-roman.
                        end. /* for each  tt-item-depos-roman */
                    end. /* IF  NOT CAN-FIND(FIRST RowErrors) */
                END. /* IF  NOT CAN-FIND(FIRST RowErrors) */
                delete tt-item-roman-faturam.
            end. /* for each tt-item-roman-faturam: */
                
            
            /*--------- INICIO UPC ---------*/
            /* S¢ para ter certeza do posicionamento do registro */
            run goToKey  in h-bodi509 (input tt-roman-faturam.num-romaneio).
            run getRowid in h-bodi509 (output vRowRomaneio).
            
            for each tt-epc where tt-epc.cod-event = "receiverRomaneio":
                delete tt-epc.
            end.
                
            create tt-epc.
            assign tt-epc.cod-event     = "receiverRomaneio" 
                   tt-epc.cod-parameter = "rowidRomaneio"
                   tt-epc.val-parameter = string(vRowRomaneio).

            {include/i-epc201.i "receiverRomaneio"}
            /*--------- Final UPC ---------*/
            
        END. /* IF  NOT CAN-FIND(FIRST RowErrors) */
    END. /* WHEN "add" THEN DO: */
  
    WHEN "upd" THEN DO:
        run validaXMLRomaneio in h-bodi509 (input tt-roman-faturam.num-romaneio,
                                            INPUT tt-roman-faturam.nome-abrev,
                                            INPUT tt-roman-faturam.nr-pedcli,
                                            INPUT cTranAction, 
                                            INPUT tt-roman-faturam.idi-tip-roman).
       
        if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ then do:
            run piValidaDev-estabel in h-bodi509 (input tt-roman-faturam.cod-estabel).
        end. /* if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */  */
       
        run getRowErrors     in h-bodi509 (output table RowErrors).

        IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
            run updateRecord in h-bodi509.
            run getRowErrors in h-bodi509 (output table RowErrors).
        
            IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
                for each tt-item-roman-faturam:
                    run openQueryStatic       in h-bodi510 (input "Main":U) no-error.
                    if return-value = 'NOK' then run emptyRowErrors  in h-bodi510.
                    run goToKey               in h-bodi510 (input tt-item-roman-faturam.num-romaneio, input tt-item-roman-faturam.nr-sequencia).
                    run validaXMLRomaneioItem in h-bodi510 (input tt-item-roman-faturam.num-romaneio,
                                                            input tt-item-roman-faturam.it-codigo,
                                                            input tt-item-roman-faturam.cod-refer,              
                                                            input tt-item-roman-faturam.cod-unid-item-roman[1], 
                                                            input tt-item-roman-faturam.cod-unid-item-roman[2], 
                                                            input tt-item-roman-faturam.nr-seq-ped,             
                                                            input tt-item-roman-faturam.qtd-romaneio[1],        
                                                            input tt-item-roman-faturam.qtd-romaneio[2],        
                                                            INPUT tt-roman-faturam.nr-pedcli,                   
                                                            INPUT tt-roman-faturam.nome-abrev,
                                                            input tt-roman-faturam.idi-tip-roman). 
                    

                    if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ then do:
                        &if '{&BF_DIS_VERSAO_EMS}' < '2.08' &then
                            run piValidaDev in h-bodi510 (input substring(tt-item-roman-faturam.cod-livre-2,1,3),
                                                          input substring(tt-item-roman-faturam.cod-livre-2,4,16),
                                                          input tt-roman-faturam.nome-abrev,
                                                          input tt-item-roman-faturam.it-codigo,
                                                          input tt-item-roman-faturam.cod-refer,
                                                          input tt-item-roman-faturam.nr-seq-ped,
                                                          input substring(tt-item-roman-faturam.cod-livre-2,20,6),
                                                          input tt-item-roman-faturam.qtd-romaneio[1]).
                          
                        &else
                            run piValidaDev in h-bodi510 (input tt-item-roman-faturam.cod-ser-docto-orig,
                                                          input tt-item-roman-faturam.cod-docto-orig,
                                                          input tt-roman-faturam.nome-abrev,
                                                          input tt-item-roman-faturam.it-codigo,
                                                          input tt-item-roman-faturam.cod-refer,
                                                          input tt-item-roman-faturam.nr-seq-ped,
                                                          input substring(tt-item-roman-faturam.cod-livre-2,20,6),
                                                          input tt-item-roman-faturam.qtd-romaneio[1]).
                        &endif
                    end. /* if  tt-roman-faturam.idi-tip-roman = 4 /* Devolu‡Æo */ */

                    run getRowErrors in h-bodi510 (output table RowErrors).

                    IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
                        run setRecord    in h-bodi510 (input table tt-item-roman-faturam).
                        run updateRecord in h-bodi510.
                        run getRowErrors in h-bodi510 (output table RowErrors).

                        IF  NOT CAN-FIND(FIRST RowErrors) THEN DO:
                            for each  tt-item-depos-roman 
                                where tt-item-depos-roman.num-romaneio = tt-item-roman-faturam.num-romaneio
                                and   tt-item-depos-roman.nr-sequencia = tt-item-roman-faturam.nr-sequencia
                                and   tt-item-depos-roman.it-codigo    = tt-item-roman-faturam.it-codigo
                                and   tt-item-depos-roman.cod-refer    = tt-item-roman-faturam.cod-refer:

                                run openQueryStatic        in h-bodi511 (input "Main":U) no-error.
                                if return-value = 'NOK' then run emptyRowErrors  in h-bodi511.
                                run goToKey in h-bodi511 (input tt-item-depos-roman.num-romaneio,
                                                          input tt-item-depos-roman.nr-sequencia,
                                                          input tt-item-depos-roman.it-codigo,
                                                          input tt-item-depos-roman.cod-refer,
                                                          input tt-item-depos-roman.cod-depos,
                                                          input tt-item-depos-roman.cod-localiz,
                                                          input tt-item-depos-roman.nr-serlote).
                                run validaXMLRomaneioDepos in h-bodi511 (input tt-item-depos-roman.cod-depos).
                                run getRowErrors in h-bodi511 (output table RowErrors).

                                if  not can-find (first RowErrors) then do:
                                    run setRecord    in h-bodi511 (input table tt-item-depos-roman).
                                    run updateRecord in h-bodi511.
                                    run getRowErrors in h-bodi511 (output table RowErrors).
                                end. /* IF  NOT CAN-FIND(FIRST RowErrors) */
                                delete tt-item-depos-roman.
                            end. /* for each  tt-item-depos-roman */
                        end. /* IF  NOT CAN-FIND(FIRST RowErrors) */
                    end. /* IF  NOT CAN-FIND(FIRST RowErrors) */
                    delete tt-item-roman-faturam.
                end. /* for each tt-item-roman-faturam: */
            end. /* IF  NOT CAN-FIND(FIRST RowErrors) */
        end. /* IF  NOT CAN-FIND(FIRST RowErrors) */
    end. /* WHEN "upd" THEN DO: */
end case. /* CASE cTranAction: */

IF VALID-HANDLE(h-bodi509) THEN DO:
    DELETE PROCEDURE h-bodi509.
    ASSIGN h-bodi509 = ?.
END.

IF VALID-HANDLE(h-bodi510) THEN DO:
    DELETE PROCEDURE h-bodi510.
    ASSIGN h-bodi510 = ?.
END.

IF VALID-HANDLE(h-bodi511) THEN DO:
    DELETE PROCEDURE h-bodi511.
    ASSIGN h-bodi511 = ?.
END.

/*--- Para apresentar o problema no extrato de versÆo ------------------------------*/
IF  c-arquivo-log <> "" THEN DO:
    IF  ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execu¯Êo do programa */
        DO  iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
    END.
    OUTPUT TO value(c-arquivo-log) APPEND.
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-adapter-romaneio AS CHARACTER FORMAT "X(20)" NO-UNDO.
    {utp/ut-liter.i "Adapter_Romaneio" *}
    ASSIGN c-lbl-liter-adapter-romaneio = TRIM(RETURN-VALUE).
    PUT SKIP(1) c-lbl-liter-adapter-romaneio + ": " cErrorText FORMAT "x(200)".
    OUTPUT CLOSE.
END.
/*----------------------------------------------------------------------------------*/
