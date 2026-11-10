PROCEDURE PITransUpsert:

/* Buffers */
DEF BUFFER b_emitente_matriz FOR emitente.
def buffer b-portador-prefer for portador.
def buffer b-portador-ap     for portador.

/*PARAMETERS - BEGIN*/

DEF INPUT PARAM rw-emitente AS ROWID NO-UNDO.
DEF INPUT PARAM p-acao      AS CHAR  NO-UNDO.  /* --- opções: ADD ou UPD ---- */
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/

def var h-spp883za as handle no-undo.
DEF VAR v-num-cont-emit AS INTEGER NO-UNDO.
DEF VAR v-log-cta-fornec AS LOGICAL INIT YES NO-UNDO.

/* PCREQ-9042 - Portador do Emitente */
def var h-api              as handle  no-undo.
def var l-fn-port-emitente as logical no-undo.
def var i-portador         like emitente.portador      no-undo.
def var i-portador-ap      like emitente.portador-ap   no-undo.
def var i-port-prefer      like emitente.port-prefer   no-undo.
def var i-modalidade       like emitente.modalidade    no-undo.
def var i-mod-prefer       like emitente.mod-prefer    no-undo.
def var i-modalidade-ap    like emitente.modalidade-ap no-undo.

/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

/* PCREQ-9042 - Portador do Emitente */
{cdp/cdapi3009.i2}

FOR EACH tt_log_erro EXCLUSIVE-LOCK:
    DELETE tt_log_erro.
END.
FOR EACH ttContactClassInformation EXCLUSIVE-LOCK:
    DELETE ttContactClassInformation.
END.
FOR EACH ttContactLanguageInformation EXCLUSIVE-LOCK:
    DELETE ttContactLanguageInformation.
END.
FOR EACH ttCorporateActivityInform_00 EXCLUSIVE-LOCK:
    DELETE ttCorporateActivityInform_00.
END.
FOR EACH ttCorporateMarketActivity_00 EXCLUSIVE-LOCK:
    DELETE ttCorporateMarketActivity_00.
END.
FOR EACH ttCorporateShipToAddressI_00 EXCLUSIVE-LOCK:
    DELETE ttCorporateShipToAddressI_00.
END.
FOR EACH ttCorporateSizeInformation EXCLUSIVE-LOCK:
    DELETE ttCorporateSizeInformation.
END.
FOR EACH ttCustomerHistoryInformation EXCLUSIVE-LOCK:
    DELETE ttCustomerHistoryInformation.
END.
FOR EACH ttCustomerVendorContactIn_00 EXCLUSIVE-LOCK:
    DELETE ttCustomerVendorContactIn_00.
END.
FOR EACH ttInformacaoBancarias EXCLUSIVE-LOCK:
    DELETE ttInformacaoBancarias.
END.
FOR EACH ttInformacaoBancFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoBancFornec.
END.
FOR EACH ttInformacaoComunicCliFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoComunicCliFornec.
END.
FOR EACH ttInformacaoEndCliFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoEndCliFornec.
END.
FOR EACH ttInformacaoEndCobr EXCLUSIVE-LOCK:
    DELETE ttInformacaoEndCobr.
END.
FOR EACH ttInformacaoEspecifCliente EXCLUSIVE-LOCK:
    DELETE ttInformacaoEspecifCliente.
END.
FOR EACH ttInformacaoEspecifFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoEspecifFornec.
END.
FOR EACH ttInformacaoEspecificaPF EXCLUSIVE-LOCK:
    DELETE ttInformacaoEspecificaPF.
END.
FOR EACH ttInformacaoEspecificaPJ EXCLUSIVE-LOCK:
    DELETE ttInformacaoEspecificaPJ.
END.
FOR EACH ttInformacaoGrupoCliente EXCLUSIVE-LOCK:
    DELETE ttInformacaoGrupoCliente.
END.
FOR EACH ttInformacaoGrupoFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoGrupoFornec.
END.
FOR EACH ttInformacaoIDICliFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoIDICliFornec.
END.
FOR EACH ttInformacaoMatrizCliFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoMatrizCliFornec.
END.
FOR EACH ttInformacaoPortador EXCLUSIVE-LOCK:
    DELETE ttInformacaoPortador.
END.
FOR EACH ttInformacaoPortFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoPortFornec.
END.
FOR EACH ttInformacaoPortPreferencial EXCLUSIVE-LOCK:
    DELETE ttInformacaoPortPreferencial.
END.
FOR EACH ttInformacaoRepres EXCLUSIVE-LOCK:
    DELETE ttInformacaoRepres.
END.
/*
FOR EACH ttInformacaoTipoCliFornec EXCLUSIVE-LOCK:
    DELETE ttInformacaoTipoCliFornec.
END.
*/
/*
FOR EACH ttInformacaoTipoFluxoFinanc EXCLUSIVE-LOCK:
    DELETE ttInformacaoTipoFluxoFinanc.
END.
*/
FOR EACH ttLogisticsInformation EXCLUSIVE-LOCK:
    DELETE ttLogisticsInformation.
END.
FOR EACH ttPhysicalEntityLanguageI_00 EXCLUSIVE-LOCK:
    DELETE ttPhysicalEntityLanguageI_00.
END.
FOR EACH ttPhysicalEntityPhoneInfo_00 EXCLUSIVE-LOCK:
    DELETE ttPhysicalEntityPhoneInfo_00.
END.
FOR EACH ttShipToLocationInformation EXCLUSIVE-LOCK:
    DELETE ttShipToLocationInformation.
END.
FOR EACH ttVendorHistoryInformation EXCLUSIVE-LOCK:
    DELETE ttVendorHistoryInformation.
END.

FIND emitente NO-LOCK
    WHERE ROWID(emitente) = rw-emitente NO-ERROR.
IF AVAIL emitente THEN DO:
    FIND FIRST banco NO-LOCK
        WHERE banco.cod-banco = emitente.cod-banco NO-ERROR.

    FIND FIRST gr-cli NO-LOCK
        WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

    FIND FIRST grupo-fornec NO-LOCK
        WHERE grupo-fornec.cod-gr-forn = emitente.cod-gr-forn NO-ERROR.

    FIND FIRST cond-pagto NO-LOCK
        WHERE cond-pagto.cod-cond-pag = emitente.cod-cond-pag NO-ERROR.

    FIND FIRST repres NO-LOCK
        WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.

    IF emitente.tp-rec-padrao <> 0 THEN
        FIND FIRST tipo-rec-desp NO-LOCK
            WHERE tipo-rec-desp.tp-codigo = emitente.tp-rec-padrao NO-ERROR.
    ELSE 
        FIND FIRST tipo-rec-desp NO-LOCK
            WHERE tipo-rec-desp.tp-codigo = emitente.tp-desp-padrao NO-ERROR.

    FIND FIRST banco NO-LOCK
        WHERE banco.cod-banco = emitente.cod-banco NO-ERROR.

    assign i-portador       = emitente.portador   
           i-portador-ap    = emitente.portador-ap 
           i-port-prefer    = emitente.port-prefer
           i-modalidade     = emitente.modalidade
           i-modalidade-ap  = emitente.modalidade-ap
           i-mod-prefer     = emitente.mod-prefer.

    /* PCREQ-9042 - Portador do Emitente */
    if l-fn-port-emitente then do:
    
        run prgint/ufn/ufn008za.py persistent set h-api.
        if valid-handle(h-api) then do:
            empty temp-table tt_log_erro.
            run pi_busca_dados_portador_fin in h-api (input i-ep-codigo-usuario,
                                                      input i-portador,
                                                      input i-modalidade,
                                                      input emitente.cod-emitente,
                                                      input "Cliente":U,
                                                      input "":U,
                                                      output i-portador,
                                                      output i-modalidade,
                                                      output table tt_log_erro).
            if log-manager:logging-level > 2 then do:
                for each tt_log_erro:
                    log-manager:write-message("Portador do Cliente":U, "UFN008ZA":U).
                    log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
    	            log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                    log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                end.
            end.
            empty temp-table tt_log_erro.
            run pi_busca_dados_portador_fin in h-api (input i-ep-codigo-usuario,
                                                      input i-port-prefer,
                                                      input i-mod-prefer,
                                                      input emitente.cod-emitente,
                                                      input "Cliente":U,
                                                      input "Prefer":U,
                                                      output i-port-prefer,
                                                      output i-mod-prefer,
                                                      output table tt_log_erro).
            if log-manager:logging-level > 2 then do:
                for each tt_log_erro:
                    log-manager:write-message("Portador do Cliente Preferencial":U, "UFN008ZA":U).
                    log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
    	            log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                    log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                end.
            end.
            empty temp-table tt_log_erro.
            run pi_busca_dados_portador_fin in h-api (input i-ep-codigo-usuario,
                                                      input i-portador-ap,
                                                      input i-modalidade-ap,
                                                      input emitente.cod-emitente,
                                                      input "Fornecedor":U,
                                                      input "":U,
                                                      output i-portador-ap,
                                                      output i-modalidade-ap,
                                                      output table tt_log_erro).
            if log-manager:logging-level > 2 then do:
                for each tt_log_erro:
                    log-manager:write-message("Portador do Fornecedor":U, "UFN008ZA":U).
                    log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
    	            log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                    log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                end.
            end.
            empty temp-table tt_log_erro.
            delete procedure h-api.
        end.
    end.

    FIND FIRST portador NO-LOCK
         WHERE portador.ep-codigo    = i-ep-codigo-usuario
           AND portador.cod-portador = i-portador
           AND portador.modalidade   = i-modalidade NO-ERROR.

    FIND FIRST b-portador-prefer NO-LOCK
         WHERE b-portador-prefer.ep-codigo    = i-ep-codigo-usuario
           AND b-portador-prefer.cod-portador = i-port-prefer
           AND b-portador-prefer.modalidade   = i-mod-prefer NO-ERROR.

    FIND FIRST b-portador-ap NO-LOCK
         WHERE b-portador-ap.ep-codigo    = i-ep-codigo-usuario
           AND b-portador-ap.cod-portador = i-portador-ap
           AND b-portador-ap.modalidade   = i-modalidade-ap NO-ERROR.

    FIND FIRST pais WHERE pais.nome-pais = emitente.pais NO-LOCK NO-ERROR.

    ASSIGN v-num-cont-emit = 1.
    FOR EACH cont-emit NO-LOCK
        WHERE cont-emit.cod-emitente = emitente.cod-emitente:
        CREATE ttCustomerVendorContactIn_00.
        assign ttCustomerVendorContactIn_00.ContactSequence                = cont-emit.sequencia
               ttCustomerVendorContactIn_00.ContactName                    = cont-emit.nome
               ttCustomerVendorContactIn_00.ContactPhone                   = cont-emit.telefone
               ttCustomerVendorContactIn_00.ContactPhoneExtention          = cont-emit.ramal
               ttCustomerVendorContactIn_00.ContactArea                    = cont-emit.area
               ttCustomerVendorContactIn_00.ContactFaxNumber               = cont-emit.telefax 
               ttCustomerVendorContactIn_00.ContactFaxExtention            = cont-emit.ramal-fax 
               ttCustomerVendorContactIn_00.ContactEmail                   = cont-emit.e-mail
               ttCustomerVendorContactIn_00.ContactTitle                   = cont-emit.cargo
               ttCustomerVendorContactIn_00.Comment                        = cont-emit.observacao
               ttCustomerVendorContactIn_00.ttCustomerVendorContactIn_00ID = v-num-cont-emit
                .
        ASSIGN v-num-cont-emit = v-num-cont-emit + 1.
    END.

    ASSIGN cEvent                       = ""
           cTranAction                  = p-acao 
           CustomerVendorCode           = emitente.cod-emitente
           CustomerVendorIdentification = emitente.identific
           CustomerVendorName           = emitente.nome-emit 
           CustomerVendorShortName      = emitente.nome-abrev
           EntityType                   = emitente.natureza
           DateAdded                    = emitente.data-implant
           Comment                      = emitente.observacoes
           IdentificationType           = v-identific   /* ---   Operacional Textil - Exportacao Cliente ou fornecedor   --- */
           IdentificationAction         = v-acao        /* ---   Operacional Textil - Exportacao Cliente ou fornecedor   --- */
            .

    FIND FIRST ttInformacaoBancarias NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoBancarias THEN DO:
        CREATE ttInformacaoBancarias.
        ASSIGN ttInformacaoBancarias.BankCode                         = string(emitente.cod-banco)  
               ttInformacaoBancarias.BankInstructionCode1             = string(emitente.ins-banc[1])
               ttInformacaoBancarias.BankInstructionCode2             = string(emitente.ins-banc[2])
               ttInformacaoBancarias.BankName                         = IF AVAIL banco THEN banco.nome-banco ELSE ""
               ttInformacaoBancarias.BranchCode                       = emitente.agencia                    
               ttInformacaoBancarias.CheckingAccountNumber            = emitente.conta-corren
               ttInformacaoBancarias.ttInformacaoBancariasID          = 1
               ttInformacaoBancarias.ttInformacaoEspecifClienteID     = 1.
    END.

    IF v-log-cta-fornec
    and CAN-FIND (FIRST cta-emitente no-lock
        where cta-emitente.cod-emitente = emitente.cod-emitente) THEN DO:
        &if '{&mgadm_version}' >= '2.04' &then
            for each cta-emitente no-lock
               where cta-emitente.cod-emitente = emitente.cod-emitente:

                FIND FIRST banco NO-LOCK
                    WHERE banco.cod-banco = cta-emitente.cod-banco NO-ERROR.

                CREATE ttInformacaoBancFornec.
                ASSIGN ttInformacaoBancFornec.BankCode                         = string(cta-emitente.cod-banco)
                       ttInformacaoBancFornec.BankName                         = IF AVAIL banco THEN banco.nome-banco ELSE ""
                       ttInformacaoBancFornec.BranchCode                       = cta-emitente.agencia                            
                       ttInformacaoBancFornec.CheckingAccountNumber            = cta-emitente.conta-corren
                       ttInformacaoBancFornec.ttInformacaoBancFornecID         = 1
                       ttInformacaoBancFornec.ttInformacaoEspecifFornecID      = 1
                       ttInformacaoBancFornec.CheckingAccountDescription       = cta-emitente.descricao
                       ttInformacaoBancFornec.CheckingAccountPreferred         = cta-emitente.preferencial.
            end.
        &endif
    END.
    ELSE DO:
        FIND FIRST ttInformacaoBancFornec NO-LOCK NO-ERROR.
        IF NOT AVAIL ttInformacaoBancFornec THEN DO:
            CREATE ttInformacaoBancFornec.
            ASSIGN ttInformacaoBancFornec.BankCode                         = string(emitente.cod-banco)
                   ttInformacaoBancFornec.BankName                         = IF AVAIL banco THEN banco.nome-banco ELSE ""
                   ttInformacaoBancFornec.BranchCode                       = emitente.agencia                            
                   ttInformacaoBancFornec.CheckingAccountNumber            = emitente.conta-corren
                   ttInformacaoBancFornec.ttInformacaoBancFornecID         = 1
                   ttInformacaoBancFornec.ttInformacaoEspecifFornecID      = 1.
    END.


    END.
    FIND FIRST ttInformacaoComunicCliFornec NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoComunicCliFornec THEN DO:
        CREATE ttInformacaoComunicCliFornec.
        ASSIGN ttInformacaoComunicCliFornec.EDIPartner                     = string(emitente.cod-parceiro-edi)
               ttInformacaoComunicCliFornec.EMail                          = emitente.e-mail          
               ttInformacaoComunicCliFornec.FaxExtention                   = emitente.ramal-fax
               ttInformacaoComunicCliFornec.FaxExtention2                  = emitente.ramal-fac
               ttInformacaoComunicCliFornec.FaxNumber                      = emitente.telefax  
               ttInformacaoComunicCliFornec.FaxNumber2                     = emitente.telef-fac
               ttInformacaoComunicCliFornec.HomePage                       = emitente.home-page
               ttInformacaoComunicCliFornec.ModemExtention                 = emitente.ramal-modem
               ttInformacaoComunicCliFornec.ModemNumber                    = emitente.telef-modem
               ttInformacaoComunicCliFornec.PhoneExtention1                = emitente.ramal[1]
               ttInformacaoComunicCliFornec.PhoneExtention2                = emitente.ramal[2]
               ttInformacaoComunicCliFornec.PhoneNumber1                   = emitente.telefone[1]
               ttInformacaoComunicCliFornec.PhoneNumber2                   = emitente.telefone[2]
               ttInformacaoComunicCliFornec.ttInformacaoComunicCliFornecID = 1.
    END.

    FIND FIRST ttInformacaoEndCliFornec NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoEndCliFornec THEN DO:
        CREATE ttInformacaoEndCliFornec.
        ASSIGN ttInformacaoEndCliFornec.Address2                      = emitente.bairro
               ttInformacaoEndCliFornec.City                          = emitente.cidade
               ttInformacaoEndCliFornec.Country                       = emitente.pais
               ttInformacaoEndCliFornec.POBox                         = emitente.caixa-postal
               ttInformacaoEndCliFornec.State                         = emitente.estado
               ttInformacaoEndCliFornec.ttInformacaoEndCliFornecID    = 1
               ttInformacaoEndCliFornec.Zip                           = emitente.cep
               ttInformacaoEndCliFornec.ZipCode                       = emitente.zip-code.

        ASSIGN ttInformacaoEndCliFornec.Address = emitente.endereco.

        /* ---   Operacional Textil - Exportacao Cliente ou fornecedor   --- */
        FOR FIRST pais WHERE pais.nome-pais = emitente.pais NO-LOCK:
            ASSIGN ttInformacaoEndCliFornec.CountrySiscomex = &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN pais.cod-pais-siscomex &ELSE integer(substring(pais.char-1,1,5)) &ENDIF.
            IF ttInformacaoEndCliFornec.CountrySiscomex = 0 THEN
                ASSIGN ttInformacaoEndCliFornec.CountrySiscomex = ?.
        END.
    END.

    FIND FIRST ttInformacaoEndCobr NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoEndCobr THEN DO:
        CREATE ttInformacaoEndCobr.
        ASSIGN ttInformacaoEndCobr.Address2_00                    = emitente.bairro-cob
               ttInformacaoEndCobr.BillToCustomerCode             = emitente.end-cobranca
               ttInformacaoEndCobr.BillToTaxID                    = emitente.cgc-cob
               ttInformacaoEndCobr.BillToTaxExemptionNumber       = emitente.ins-est-cob
               ttInformacaoEndCobr.City_00                        = emitente.cidade-cob
               ttInformacaoEndCobr.Country_00                     = emitente.pais-cob
               ttInformacaoEndCobr.POBox_00                       = emitente.cx-post-cob
               ttInformacaoEndCobr.State_00                       = emitente.estado-cob
               ttInformacaoEndCobr.ttInformacaoEndCobrID          = 1
               ttInformacaoEndCobr.Zip_00                         = emitente.cep-cob     
               ttInformacaoEndCobr.ZipCode_00                     = emitente.zip-cob-code.

        ASSIGN ttInformacaoEndCobr.Address_00 = emitente.endereco-cob.

        /* ---   Operacional Textil - Exportacao Cliente ou fornecedor   --- */
        FOR FIRST pais WHERE pais.nome-pais = emitente.pais-cob NO-LOCK:
            ASSIGN ttInformacaoEndCobr.CountrySiscomex = &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN pais.cod-pais-siscomex &ELSE integer(substring(pais.char-1,1,5)) &ENDIF.
            IF ttInformacaoEndCobr.CountrySiscomex = 0 THEN
                ASSIGN ttInformacaoEndCobr.CountrySiscomex = ?.
        END.
    END.

    FIND FIRST ttInformacaoEspecifCliente NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoEspecifCliente THEN DO:
        CREATE ttInformacaoEspecifCliente.
        ASSIGN ttInformacaoEspecifCliente.DaysLate                      = emitente.nr-dias-atraso
               ttInformacaoEspecifCliente.GenerateDebitMemo             = emitente.gera-ad
               ttInformacaoEspecifCliente.MinimumAmount                 = emitente.valor-minimo
               ttInformacaoEspecifCliente.PaymentTerms                  = string(emitente.cod-cond-pag)
               ttInformacaoEspecifCliente.PaymentTermsDescription       = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "" 
               ttInformacaoEspecifCliente.PenaltyCalculation            = emitente.calcula-multa
               ttInformacaoEspecifCliente.ReceiveInformation            = emitente.recebe-inf-sci
               ttInformacaoEspecifCliente.StandardRevenueCode           = emitente.tp-rec-padrao 
               ttInformacaoEspecifCliente.StandardRevenueDescription    = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""
               ttInformacaoEspecifCliente.StatementPrint                = emitente.emite-bloq
               ttInformacaoEspecifCliente.ttInformacaoEspecifClienteID  = 1.
    END.

    FIND FIRST ttInformacaoEspecifFornec NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoEspecifFornec THEN DO:
        CREATE ttInformacaoEspecifFornec.
        ASSIGN ttInformacaoEspecifFornec.ClearanceDays                = emitente.dias-comp                                         
               ttInformacaoEspecifFornec.DiscountPercentage           = emitente.bonificacao                                       
               ttInformacaoEspecifFornec.DueEqualFlowDate             = emitente.vencto-dia-nao-util                               
               ttInformacaoEspecifFornec.DueHoliday                   = emitente.ven-feriado                                       
               ttInformacaoEspecifFornec.DueSaturday                  = emitente.ven-sabado                                        
               ttInformacaoEspecifFornec.DueSunday                    = emitente.ven-domingo                                       
               ttInformacaoEspecifFornec.FinancialRate                = emitente.taxa-financ                                       
               ttInformacaoEspecifFornec.FinancialRateDays            = emitente.nr-dias-taxa                                      
               ttInformacaoEspecifFornec.PaymentType                  = string(emitente.tp-pagto)                                  
               ttInformacaoEspecifFornec.PrintLabel                   = emitente.emite-etiq                                        
               ttInformacaoEspecifFornec.PrintPO                      = emitente.emissao-ped                                       
               ttInformacaoEspecifFornec.Revenue                      = emitente.ind-rendiment                                     
               ttInformacaoEspecifFornec.StandardExpenseDescription   = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""
               ttInformacaoEspecifFornec.StandardExpenseType          = emitente.tp-desp-padrao                                    
               ttInformacaoEspecifFornec.TaxableRevenue               = emitente.rend-tribut                                       
               ttInformacaoEspecifFornec.ttInformacaoEspecifFornecID  = 1.

        &if  "{&mgadm_version}" > "2.04" &then
            ASSIGN ttInformacaoEspecifFornec.ControlSSMaximumAmount   = emitente.log-controla-val-max-inss
                   ttInformacaoEspecifFornec.SSTaxRegistration        = emitente.cod-inscr-inss.
        &ELSE
            ASSIGN ttInformacaoEspecifFornec.ControlSSMaximumAmount   = string(entry(1,emitente.char-2,chr(10))) = "YES"
                   ttInformacaoEspecifFornec.SSTaxRegistration        = IF num-entries(emitente.char-2,CHR(10)) > 1 THEN entry(2,emitente.char-2,chr(10)) ELSE "".
        &endif
    END.

    FIND FIRST ttInformacaoGrupoCliente NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoGrupoCliente THEN DO:
        IF emitente.identific = 1
        OR emitente.identific = 3 THEN DO:
            CREATE ttInformacaoGrupoCliente.
            ASSIGN ttInformacaoGrupoCliente.CustomerGroupCode          = string(emitente.cod-gr-cli)
                   ttInformacaoGrupoCliente.CustomerGroupDescription   = IF AVAIL gr-cli THEN gr-cli.descricao ELSE ""
                   ttInformacaoGrupoCliente.ttInformacaoGrupoClienteID = 1.
        END.
    END.

    FIND FIRST ttInformacaoGrupoFornec NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoGrupoFornec THEN DO:
        IF emitente.identific = 2
        OR emitente.identific = 3 THEN DO:
            CREATE ttInformacaoGrupoFornec.
            ASSIGN ttInformacaoGrupoFornec.VendorGroupCode           = string(emitente.cod-gr-forn)
                   ttInformacaoGrupoFornec.VendorGroupDescription    = IF AVAIL grupo-fornec THEN grupo-fornec.descricao ELSE ""
                   ttInformacaoGrupoFornec.ttInformacaoGrupoFornecID = 1.
        END.
    END.

    FIND FIRST ttInformacaoIDICliFornec NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoIDICliFornec THEN DO:
        CREATE ttInformacaoIDICliFornec.
        ASSIGN ttInformacaoIDICliFornec.Registration                = emitente.ins-municipal
               ttInformacaoIDICliFornec.TaxExemptionNumber          = emitente.ins-estadual
               ttInformacaoIDICliFornec.TaxID                       = emitente.cgc         
               ttInformacaoIDICliFornec.ttInformacaoIDICliFornecID  = 1.
    END.

    FIND FIRST ttInformacaoMatrizCliFornec NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoMatrizCliFornec THEN DO:
        CREATE ttInformacaoMatrizCliFornec.
        ASSIGN ttInformacaoMatrizCliFornec.CustomerVendorMatrixCode      = emitente.cod-emit   
               ttInformacaoMatrizCliFornec.CustomerVendorMatrixName      = emitente.nome-emit  
               ttInformacaoMatrizCliFornec.CustomerVendorMatrixShortName = emitente.nome-matriz
               ttInformacaoMatrizCliFornec.ttInformacaoMatrizCliFornecID = 1.
    END.
    FIND FIRST ttInformacaoPortFornec NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoPortFornec THEN DO:
        CREATE ttInformacaoPortFornec.
        ASSIGN ttInformacaoPortFornec.CollectorCode               = string(i-portador-ap)
               ttInformacaoPortFornec.CollectorDescription        = IF AVAIL b-portador-ap THEN b-portador-ap.nome ELSE ""
               ttInformacaoPortFornec.ModalityCode                = string(i-modalidade-ap)
               ttInformacaoPortFornec.ttInformacaoEspecifFornecID = 1
               ttInformacaoPortFornec.ttInformacaoPortFornecID    = 1.
    END.
    FIND FIRST ttInformacaoPortador NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoPortador THEN DO:
        CREATE ttInformacaoPortador.
        ASSIGN ttInformacaoPortador.CollectorCode          = string(i-portador)
               ttInformacaoPortador.CollectorDescription   = IF AVAIL portador THEN portador.nome ELSE ""
               ttInformacaoPortador.ModalityCode           = string(i-modalidade)
               ttInformacaoPortador.ttInformacaoPortadorID = 1
               ttInformacaoPortador.ttInformacaoEspecifClienteID = 1.
    END.

    FIND FIRST ttInformacaoPortPreferencial NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoPortPreferencial THEN DO:
        CREATE ttInformacaoPortPreferencial.
        ASSIGN ttInformacaoPortPreferencial.CollectorCode_00               = string(i-port-prefer)
               ttInformacaoPortPreferencial.CollectorDescription_00        = IF AVAIL b-portador-prefer THEN b-portador-prefer.nome ELSE ""
               ttInformacaoPortPreferencial.ModalityCode_00                = string(i-mod-prefer)
               ttInformacaoPortPreferencial.ttInformacaoPortPreferencialID = 1
               ttInformacaoPortPreferencial.ttInformacaoEspecifClienteID   = 1.
    END.

    FIND FIRST ttInformacaoRepres NO-LOCK NO-ERROR.
    IF  NOT AVAIL ttInformacaoRepres THEN DO:
        CREATE ttInformacaoRepres.
        ASSIGN ttInformacaoRepres.RepresentativeCode         = string(emitente.cod-rep)
               ttInformacaoRepres.RepresentativeName         = IF AVAIL repres THEN repres.nome ELSE ""
               ttInformacaoRepres.ttInformacaoRepresID       = 1.
    END.

    IF l-integra-ems5 THEN DO:
        /*--- Conecta bases do EMS 5 ---*/
        {cdp/cd1202.i3 i-ep-codigo-usuario}

        run prgfin/spp/spp883za.p persistent set h-spp883za.
        run pi_envio_msg_emitente_xml in h-spp883za (INPUT CustomerVendorCode, 
                                                     INPUT CustomerVendorIdentification, 
                                                     INPUT-OUTPUT EntityCode,
                                                     INPUT EntityType, 
                                                     INPUT-OUTPUT IMAGE,
                                                     INPUT-OUTPUT VendorClassification,
                                                     INPUT-OUTPUT TABLE ttContactClassInformation,
                                                     INPUT-OUTPUT TABLE ttContactLanguageInformation, 
                                                     INPUT-OUTPUT TABLE ttCorporateActivityInform_00, 
                                                     INPUT-OUTPUT TABLE ttCorporateMarketActivity_00, 
                                                     INPUT-OUTPUT TABLE ttCorporateShipToAddressI_00, 
                                                     INPUT-OUTPUT TABLE ttCorporateSizeInformation,   
                                                     INPUT-OUTPUT TABLE ttCustomerHistoryInformation, 
                                                     INPUT-OUTPUT TABLE ttCustomerVendorContactIn_00, 
                                                     INPUT-OUTPUT TABLE ttInformacaoBancarias,        
                                                     INPUT-OUTPUT TABLE ttInformacaoComunicCliFornec, 
                                                     INPUT-OUTPUT TABLE ttInformacaoEndCliFornec,     
                                                     INPUT-OUTPUT TABLE ttInformacaoEndCobr,          
                                                     INPUT-OUTPUT TABLE ttInformacaoEspecifCliente,   
                                                     INPUT-OUTPUT TABLE ttInformacaoEspecifFornec,    
                                                     INPUT-OUTPUT TABLE ttInformacaoEspecificaPF,     
                                                     INPUT-OUTPUT TABLE ttInformacaoEspecificaPJ,     
                                                     INPUT-OUTPUT TABLE ttInformacaoIDICliFornec,     
                                                     INPUT-OUTPUT TABLE ttInformacaoPortador,         
                                                     INPUT-OUTPUT TABLE ttInformacaoPortPreferencial, 
                                                     INPUT-OUTPUT TABLE ttInformacaoTipoCliente,
                                                     INPUT-OUTPUT TABLE ttInformacaoTipoFornec,
                                                     INPUT-OUTPUT TABLE ttInformacaoGrupoCliente,
                                                     INPUT-OUTPUT TABLE ttInformacaoGrupoFornec,
                                                     INPUT-OUTPUT TABLE ttInformacaoTipoFluxoFinanc,
                                                     INPUT-OUTPUT TABLE ttPhysicalEntityLanguageI_00, 
                                                     INPUT-OUTPUT TABLE ttPhysicalEntityPhoneInfo_00, 
                                                     INPUT-OUTPUT TABLE ttVendorHistoryInformation,
                                                     INPUT-OUTPUT TABLE ttInformacaoPortFornec,
                                                     INPUT-OUTPUT TABLE ttInformacaoBancFornec).   

        delete procedure h-spp883za.

        /****   Desconecta as bases do EMS5 ****/
        {cdp/cd1202.i4 i-ep-codigo-usuario}    
    END.

    {adapters/xml/fi2/axsfi001a.i}

    RUN PIUpsert (INPUT cEvent,
                  INPUT Comment,
                  INPUT cTranAction,                 
                  INPUT CustomerVendorCode,          
                  INPUT CustomerVendorIdentification,
                  INPUT CustomerVendorName,          
                  INPUT CustomerVendorShortName,     
                  INPUT DateAdded,
                  INPUT EntityCode,                  
                  INPUT EntityType, 
                  INPUT IMAGE,
                  INPUT IdentificationType  ,
                  INPUT IdentificationAction,
                  OUTPUT TABLE tt_log_erro,                 
                  INPUT TABLE ttContactClassInformation,   
                  INPUT TABLE ttContactLanguageInformation,
                  INPUT TABLE ttCorporateActivityInform_00,
                  INPUT TABLE ttCorporateMarketActivity_00,
                  INPUT TABLE ttCorporateShipToAddressI_00,
                  INPUT TABLE ttCorporateSizeInformation,  
                  INPUT TABLE ttCustomerHistoryInformation,
                  INPUT TABLE ttCustomerVendorContactIn_00,
                  INPUT TABLE ttInformacaoBancarias,       
                  INPUT TABLE ttInformacaoBancFornec,
                  INPUT TABLE ttInformacaoComunicCliFornec,
                  INPUT TABLE ttInformacaoEndCliFornec,    
                  INPUT TABLE ttInformacaoEndCobr,         
                  INPUT TABLE ttInformacaoEspecifCliente,  
                  INPUT TABLE ttInformacaoEspecifFornec,   
                  INPUT TABLE ttInformacaoEspecificaPF,    
                  INPUT TABLE ttInformacaoEspecificaPJ,    
                  INPUT TABLE ttInformacaoGrupoCliente,
                  INPUT TABLE ttInformacaoGrupoFornec,  
                  INPUT TABLE ttInformacaoIDICliFornec,    
                  INPUT TABLE ttInformacaoMatrizCliFornec, 
                  INPUT TABLE ttInformacaoPortador,        
                  INPUT TABLE ttInformacaoPortFornec,
                  INPUT TABLE ttInformacaoPortPreferencial,
                  INPUT TABLE ttInformacaoRepres,
                  INPUT TABLE ttInformacaoTipoCliente,
                  INPUT TABLE ttInformacaoTipoFluxoFinanc,
                  INPUT TABLE ttInformacaoTipoFluxoFornec,
                  INPUT TABLE ttInformacaoTipoFornec,
                  INPUT TABLE ttLogisticsInformation,      
                  INPUT TABLE ttPhysicalEntityLanguageI_00,
                  INPUT TABLE ttPhysicalEntityPhoneInfo_00,
                  INPUT TABLE ttShipToLocationInformation,
                  INPUT TABLE ttVendorHistoryInformation,
                  INPUT VendorClassification).

END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

