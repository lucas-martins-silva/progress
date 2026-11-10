
 /* axrvd003Upsert.i INCLUS«O/ALTERAÄ«O DE PEDIDOS DE VENDA ->>  */

  EMPTY TEMP-TABLE RowErrors NO-ERROR.

if  search("pdp/pdapi500.r":U) <> ? then do:
    if  cTranAction = "upd":U then 
        case cTranEvent:
            when "CancelOrder":U     then assign pTranAction = "cancel":U.
            when "SuspendOrder":U    then assign pTranAction = "suspend":U.
            when "ReactivateOrder":U then assign pTranAction = "reactivate":U.
            when "":U                then assign pTranAction = cTranAction.
        end case.
    else assign pTranAction = cTranAction. /* add */

    FIND FIRST tt-ped-venda NO-LOCK NO-ERROR.
    ASSIGN c-ped-venda = tt-ped-venda.nr-pedcli + ";" + tt-ped-venda.nome-abrev.

    run pdp/pdapi500.p (input  pTranAction,
                        input  0,
                        input  table tt-ped-venda,
                        input  table tt-ped-item,
                        input  table tt-desc-ped-item,
                        input  table tt-ped-ent,
                        input  table tt-unid-neg-ped,
                        input  table tt-cond-ped,
                        input  table tt-ped-repre,
                        input  table tt-ped-pag-antecipado,
                        input  table tt-pd-vendor,
                        output table RowErrors, 
                        output table ReturnOrderValues,
                        output table ReturnItemValues) .

    IF  ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
        DO  iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'pdp/pdapi500.p'_pelo_programa_adapters/xml/vd2/axrvd003.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_Progress" *}
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT RETURN-VALUE + ': ' + cErrorText).
    END.
    else do:
        /*---[ IN÷CIO EPC ]-------------------------------------------------------------------*/
        if  c-nom-prog-upc-mg97 <> "" then do:

            for each tt-epc where tt-epc.cod-event = "LISTA-PEDIDOS":            delete tt-epc. end.
            for each tt-epc where tt-epc.cod-event = 'integracao-data-invalida': delete tt-epc. end.
            
            /*---[ handle da temp-table de pedidos ]------------------------------------------*/
            create tt-epc.
            assign tt-epc.cod-event     = "LISTA-PEDIDOS"
                   tt-epc.cod-parameter = "HANDLE-TT-PED-VENDA"
                   tt-epc.val-parameter = string(temp-table tt-ped-venda:handle) + ";" + string(temp-table tt-inform-adicional:handle) + ";".

            {include/i-epc201.i "LISTA-PEDIDOS"}

            if  can-find(first tt-epc
                         where tt-epc.cod-event     = 'integracao-data-invalida'
                         and   tt-epc.cod-parameter = 'integracao-data-invalida') then do:
                
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-data-de-frete-especial-invalid AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Data_de_frete_especial_inv†lida" *}
                ASSIGN c-lbl-liter-data-de-frete-especial-invalid = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-mes-deve-estar-entre-1-e-12 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Màs_deve_estar_entre_1_e_12" *}
                ASSIGN c-lbl-liter-mes-deve-estar-entre-1-e-12 = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input 'msg', input 15825, input c-lbl-liter-data-de-frete-especial-invalid + '.' + '~~' + c-lbl-liter-mes-deve-estar-entre-1-e-12).

                create RowErrors.
                create RowErrors.
                assign RowErrors.ErrorNumber      = 15825
                       RowErrors.ErrorDescription = trim(RETURN-VALUE)
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "WARNING":U.

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-data-de-frete-especial-invalid-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Data_de_frete_especial_inv†lida" *}
                ASSIGN c-lbl-liter-data-de-frete-especial-invalid-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-mes-deve-estar-entre-1-e-13 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Màs_deve_estar_entre_1_e_12" *}
                ASSIGN c-lbl-liter-mes-deve-estar-entre-1-e-13 = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input 'help', input 15825, input c-lbl-liter-data-de-frete-especial-invalid-2 + '.' + '~~' + c-lbl-liter-mes-deve-estar-entre-1-e-13).
                
                assign RowErrors.ErrorHelp = trim(RETURN-VALUE).
            end. /* if  can-find(first tt-epc */
        end. /* if  c-nom-prog-upc-mg97 <> "" */
        /*-------------------------------------------------------------------[ IN÷CIO EPC ]---*/
    end.

    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        FIND FIRST tt-ped-venda NO-LOCK NO-ERROR.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "EnviaEmail"
               tt-epc.cod-parameter = "C-TT-PED-VENDA"
               tt-epc.val-parameter = c-ped-venda.

        FOR EACH RowErrors:
            ASSIGN c-ped-venda-erro = c-ped-venda-erro + RowErrors.ErrorDescription + " ".
        END.

        IF c-ped-venda-erro <> "" THEN DO:
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "EnviaEmail"
                   tt-epc.cod-parameter = "cErrorText".
                   tt-epc.val-parameter = c-ped-venda + ";" + c-ped-venda-erro.
        END.
    
        {include/i-epc201.i "EnviaEmail"}
    END.

END.
ELSE /* Programa de efetivaá∆o n∆o localizado */
    /* Inicio -- Projeto Internacional */
    DO:
    {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'pdp/pdapi500.p'_a_ser_executado_pelo_programa_adapters/xml/vd2/axrvd003.p" *}
    RUN setError IN hMessageHandler (INPUT 0,
                                     INPUT "enviroment_error":U,
                                     INPUT RETURN-VALUE + '.').
    END. 




