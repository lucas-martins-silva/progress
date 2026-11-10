
    /* Integraá∆o via EMS2 */
    /* Buscar a sequencia do pr¢ximo emitente */
    run cdp/cd9960.p (output i-emitente).

    ASSIGN tt-integra-fornecedor.cod-emitente = i-emitente
           tt-integra-fornecedor.nome-abrev   = SUBSTRING(STRING(i-emitente),1,12)
           tt-integra-fornecedor.nome-matriz  = SUBSTRING(STRING(i-emitente),1,12).

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN 
        ASSIGN tt-integra-fornecedor.ep-codigo-prin = string(param-global.empresa-prin)
               tt-integra-fornecedor.ep-codigo      = string(param-global.empresa-prin)
               v-cod-empres-usuar                   = param-global.empresa-prin.

    FIND FIRST portador NO-LOCK
         WHERE portador.ep-codigo = v-cod-empres-usuar NO-ERROR.
    IF AVAIL portador THEN
        ASSIGN tt-integra-fornecedor.cod-portador = STRING(portador.cod-portador)
               tt-integra-fornecedor.modalidade   = STRING(portador.modalidade).

    FIND FIRST grupo-fornec NO-LOCK NO-ERROR.
    IF AVAIL grupo-fornec THEN
        ASSIGN tt-integra-fornecedor.cod-gr-forn = string(grupo-fornec.cod-gr-forn).

    FIND FIRST tipo-rec-desp NO-LOCK
         WHERE tipo-rec-desp.tipo = 2 /* Despesas */ NO-ERROR.
    IF AVAIL tipo-rec-desp THEN
        ASSIGN tt-integra-fornecedor.tp-desp-padrao = STRING(tipo-rec-desp.tp-codigo).

    ASSIGN c-cod-arquivo-log = SESSION:TEMP-DIRECTORY + "integra-fornec":U + ".tmp":U.

    CREATE tt_emitente_integr_new.
    ASSIGN tt_emitente_integr_new.cod_versao_integracao = 1
           tt_emitente_integr_new.cod_emitente          = tt-integra-fornecedor.cod-emitente
           tt_emitente_integr_new.identific             = 2 /* Fornecedor */
           tt_emitente_integr_new.nome_abrev            = tt-integra-fornecedor.nome-abrev
           tt_emitente_integr_new.nome_matriz           = tt-integra-fornecedor.nome-matriz
           tt_emitente_integr_new.natureza              = tt-integra-fornecedor.natureza-EMS2 /* 1 - Pessoa F°sica, 2 - Pessoa Juridica */
           tt_emitente_integr_new.cgc                   = tt-integra-fornecedor.cgc
           tt_emitente_integr_new.cod_portador          = INT(tt-integra-fornecedor.cod-portador)
           tt_emitente_integr_new.modalidade            = INT(tt-integra-fornecedor.modalidade)
           tt_emitente_integr_new.data_implant          = TODAY
           tt_emitente_integr_new.cod_gr_forn           = int(tt-integra-fornecedor.cod-gr-forn)
           tt_emitente_integr_new.ins_estadual          = IF tt-integra-fornecedor.ins-estadual <> "" THEN tt-integra-fornecedor.ins-estadual ELSE 'isento'
           tt_emitente_integr_new.ins_municipal         = IF tt-integra-fornecedor.ins-municipal <> "" THEN tt-integra-fornecedor.ins-municipal ELSE 'isento'
           tt_emitente_integr_new.estado                = tt-integra-fornecedor.estado
           tt_emitente_integr_new.endereco              = tt-integra-fornecedor.endereco
           tt_emitente_integr_new.bairro                = tt-integra-fornecedor.bairro
           tt_emitente_integr_new.cep                   = tt-integra-fornecedor.cep
           tt_emitente_integr_new.cod_pais              = "BRASIL"
           tt_emitente_integr_new.nom_cidade            = tt-integra-fornecedor.cidade
           tt_emitente_integr_new.telefone              = tt-integra-fornecedor.telefone
           tt_emitente_integr_new.home_page             = tt-integra-fornecedor.homepage
           tt_emitente_integr_new.zip_code              = IF tt-integra-fornecedor.cep = "" THEN "00000000" ELSE tt-integra-fornecedor.cep
           tt_emitente_integr_new.ven_sabado            = 1
           tt_emitente_integr_new.ven_domingo           = 1
           tt_emitente_integr_new.ven_feriado           = 1
           tt_emitente_integr_new.e_mail                = tt-integra-fornecedor.email
           tt_emitente_integr_new.nome_emit             = tt-integra-fornecedor.nome-emit
           tt_emitente_integr_new.ep_codigo             = tt-integra-fornecedor.ep-codigo
           tt_emitente_integr_new.ep_codigo_principal   = tt-integra-fornecedor.ep-codigo-prin
           tt_emitente_integr_new.num_tip_operac        = 1 /* ( 1 - Inclus∆o/Modificaá∆o, 2 - Eliminaá∆o) */
           tt_emitente_integr_new.tp_desp_padrao        = int(tt-integra-fornecedor.tp-desp-padrao).

    CREATE tt_cont_emit_integr_new.
    ASSIGN tt_cont_emit_integr_new.cod_versao_integracao = 1
           tt_cont_emit_integr_new.cod_emitente          = tt-integra-fornecedor.cod-emitente
           tt_cont_emit_integr_new.nome                  = tt-integra-fornecedor.nome-emit
           tt_cont_emit_integr_new.ep_codigo_principal   = tt-integra-fornecedor.ep-codigo-prin
           tt_cont_emit_integr_new.num_tip_operac        = 1.

    RUN cdp/cdapi366b.p PERSISTENT SET h-cdapi366b.

    /* Executa procedure evoluida */
    RUN execute_evoluida_8 IN h-cdapi366b (INPUT        TABLE tt_emitente_integr_new,
                                           INPUT        TABLE tt_cont_emit_integr_new,
                                           INPUT-OUTPUT TABLE tt_retorno_clien_fornec,
                                           INPUT              "",
                                           INPUT-OUTPUT       c-cod-arquivo-log,
                                           INPUT        TABLE tt_cta_emitente).


    ASSIGN c-cod-fornecedor = i-emitente.

    DELETE PROCEDURE h-cdapi366b.
    
    /************* Integracao 2.00 X 5.00 *****************/
    find first emitente
         where emitente.cod-emitente = i-emitente no-lock no-error.
    IF AVAIL emitente THEN DO:
        if  can-find(funcao where funcao.cd-funcao = "adm-cdf-ems-5.00"
            and funcao.ativo = yes
            and funcao.log-1 = yes) then do:
            find first param-global no-lock no-error.
            if param-global.log-2 = yes then do:
                  validate emitente no-error.
                  run cdp/cd1608.p (input emitente.cod-emitente,
                                    input emitente.cod-emitente,
                                    input emitente.identific,
                                    input yes,
                                    input 1,
                                    input 0,
                                    input c-cod-arquivo-log /*"utb765zb.tmp"*/,
                                    input "Arquivo":U,
                                    input "").
            end.
        end.
    END.
    /*********** Fim Integracao 2.00 X 5.00 ****************/    

