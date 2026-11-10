/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT005 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft005 MAN}
&ENDIF

{cdp/cdcfgdis.i}
/******************************************************************************
**  Programa: aneft005.p 
**  Funcao  : Sender de Clientes
**  Data    : 09/2002
**  Autor   : 
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE estabelec.cod-estabel NO-UNDO.

DEF VAR c-root               AS CHAR NO-UNDO.
DEF VAR c-message            AS CHAR NO-UNDO.
DEF VAR c-campo              AS CHAR NO-UNDO.
DEF VAR c-FromRole           AS CHAR NO-UNDO.
DEF VAR c-ToRole             AS CHAR NO-UNDO.
DEF VAR c-UpdatePartner      AS CHAR NO-UNDO.
DEF VAR c-PartnerCollection  AS CHAR NO-UNDO.
DEF VAR c-PartnerInformation AS CHAR NO-UNDO.

/* PCREQ-9042 - Portador do Emitente */
define variable i-portador    as integer no-undo.
define variable i-modalidade  as integer no-undo.
define variable i-port-prefer as integer no-undo.
define variable i-mod-prefer  as integer no-undo.
{cdp/cdapi3009.i1}
{cdp/cdapi3009.i2}

{adapters/neogrid/include/anein004.i} /*sender*/

IF  p-rowid <> ? THEN DO:

    FIND emitente WHERE ROWID(emitente) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL emitente THEN DO:
        RUN pi-cabecalho-msg.
        RUN pi-corpo-msg.
        RUN pi-rodape-msg.
        WRITExml().
    END.
END.

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdatePartners","1.01.001","1")
             c-message = AddElement(c-root,"Message")
               c-UpdatePartner = AddElement(c-message,"UpdatePartners")
                 c-PartnerCollection = AddElement(c-UpdatePartner,"PartnerCollection")
                 c-FromRole = AddElement(c-UpdatePartner,"FromRole")
                 c-ToRole = AddElement(c-UpdatePartner,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-PartnerInformation = AddElement(c-PartnerCollection,"UpdateEstablishment").
    RUN pi-PartnerInformation-msg.
   /* RUN pi-CommunicationInformation-msg.
    RUN pi-TAXInformation-msg.
    RUN pi-CreditInformation-msg.
    RUN pi-FinancialInformation-msg. 
    RUN pi-VendorInformation-msg.    */
    RUN pi-PartnerRoles-msg.
    RUN pi-IdentificationCollection-msg.
    RUN pi-AddressCollection-msg.
    RUN pi-ContactCollection-msg.
END PROCEDURE.
                                                                                            
PROCEDURE pi-PartnerInformation-msg:
    DEF VAR c-EstablishmentInformation AS CHAR NO-UNDO.
    DEF VAR c-EstabRepresCollection                 AS CHAR NO-UNDO.
    DEF VAR c-EstablishmentRepresentative           AS CHAR NO-UNDO.
    DEF VAR c-Individual               AS CHAR NO-UNDO.
    DEFINE VARIABLE c-aux AS CHARACTER  NO-UNDO.
    ASSIGN c-EstablishmentInformation = AddElement(c-PartnerInformation,"EstablishmentInformation")
             c-campo = AddEleInt(c-EstablishmentInformation,"InternalCode",emitente.cod-emitente) 
             c-aux   = addelement(c-EstablishmentInformation,"Legal")
                c-campo = AddEleChar(c-aux,"ShortName",emitente.nome-abrev)   
             c-campo = AddEleChar(c-EstablishmentInformation,"LegalName",emitente.nome-emit)
             c-campo = AddEleChar(c-EstablishmentInformation,"Status","1")
             c-campo = AddEleChar(c-EstablishmentInformation,"URL",emitente.home-page)
                  c-campo = AddEleChar(c-EstablishmentInformation,"MainIdentification","CNPJ").
         /*    c-campo = AddEleChar(c-EstablishmentInformation,"CustomerClassificationCode",IF emitente.cod-classif-cliente <> 0  
                                                                                          THEN ENTRY(emitente.cod-classif-cliente,{adinc/i29ad098.i 03})
                                                                                          ELSE "")
             c-campo = AddEleDeci(c-EstablishmentInformation,"Discount",emitente.bonificacao)
             c-Individual = AddElement(c-EstablishmentInformation,"Individual")
               c-campo = AddEleChar(c-Individual,"Birthday","")   
               c-campo = AddEleChar(c-Individual,"MotherName","")   
               c-campo = AddEleChar(c-Individual,"FatherName","")   
             c-campo = AddEleChar(c-EstablishmentInformation,"Type",string(emitente.natureza))
             c-campo = AddEleChar(c-EstablishmentInformation,"HoldingCompany",emitente.nome-matriz)                
             c-campo = AddEleInt(c-EstablishmentInformation,"CustomerGroup",emitente.cod-gr-cli)
             c-campo = AddEleChar(c-EstablishmentInformation,"MarketActivity",emitente.atividade)
             c-campo = AddEleChar(c-EstablishmentInformation,"Category",emitente.categoria)
             c-campo = AddEleChar(c-EstablishmentInformation,"ProductLine",emitente.linha-produt)
             c-campo = AddEleInt(c-EstablishmentInformation,"RepresentativeCode",emitente.cod-rep). */

    /*
    FIND repres WHERE repres.cod-rep = emitente.cod-rep no-lock no-error.            
    ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"Representative",IF AVAIL repres 
                                                                            THEN repres.nome-abrev
                                                                            ELSE "").*/
    /*     c-campo = AddEleChar(c-EstablishmentInformation,"MicroTerritory",emitente.nome-mic-reg)
           c-campo = AddEleInt(c-EstablishmentInformation,"Carrier",emitente.cod-transp)
           c-campo = AddEleChar(c-EstablishmentInformation,"ReshipmentCarrier",emitente.nome-tr-red)
           c-campo = AddEleDate(c-EstablishmentInformation,"RegisterDate",emitente.data-implant,"")
           c-campo = AddEleChar(c-EstablishmentInformation,"TransactionType",emitente.nat-operacao)
           c-campo = AddEleChar(c-EstablishmentInformation,"InterstateTransactionType",emitente.nat-ope-ext)
           c-campo = AddEleInt(c-EstablishmentInformation,"StdRevenueCode",emitente.tp-rec-padrao)
           c-campo = AddElechar(c-EstablishmentInformation,"ExpenseCollectCode",ENTRY(emitente.tip-cob-desp,{diinc/i04di072.i 03}))
           c-campo = AddEleInt(c-EstablishmentInformation,"DistributionChannelCode",emitente.cod-canal-venda)
           c-campo = AddEleChar(c-EstablishmentInformation,"PriceTable",emitente.nr-tabpre)
           c-campo = AddEleChar(c-EstablishmentInformation,"SalesOrderStdClassCode",ENTRY(emitente.esp-pd-venda,{adinc/i06ad098.i 03})) 
           c-campo = AddEleChar(c-EstablishmentInformation,"PartialInvoicing",string(emitente.ind-fat-par))
           c-campo = AddEleDeci(c-EstablishmentInformation,"PartialInvoicingMin",emitente.per-minfat)
           c-campo = AddEleDeci(c-EstablishmentInformation,"BalanceCancMax",emitente.per-max-canc)
           c-campo = AddEleInt(c-EstablishmentInformation,"OrderInvoicingMax",emitente.perc-fat-ped)
           c-campo = AddEleChar(c-EstablishmentInformation,"Comments",emitente.observacoes)
           c-campo = AddEleChar(c-EstablishmentInformation,"Ship-toComments",emitente.obs-entrega)
           c-campo = AddEleInt(c-EstablishmentInformation,"Bill-toAddressCode",emitente.end-cobranca)
           /*c-campo = AddEleDeci(c-EstablishmentInformation,"PublicityPercent",emitente.percent-verba)
           c-campo = AddEleChar(c-EstablishmentInformation,"UsePublicityGrant",string(emitente.utiliza-verba))*/
           c-campo = AddEleInt(c-EstablishmentInformation,"StdMessageCode",emitente.cod-mensagem)
           c-campo = AddEleChar(c-EstablishmentInformation,"PrintLabel",string(emitente.emite-etiq))
           c-campo = AddEleChar(c-EstablishmentInformation,"InventoryAllocation",ENTRY(emitente.estoque,{adinc/i25ad098.i 03})) 
           c-campo = AddEleInt(c-EstablishmentInformation,"EndTimeDelivery",emitente.hora-fim)
           c-campo = AddEleInt(c-EstablishmentInformation,"StartTimeDelivery",emitente.hora-ini)
           c-campo = AddEleChar(c-EstablishmentInformation,"LateIndicator",ENTRY(emitente.ind-atraso,{adinc/i18ad098.i 03}))
           c-campo = AddEleChar(c-EstablishmentInformation,"QuantityType",ENTRY(emitente.tp-qt-prg,{adinc/i23ad098.i 03}))
           c-campo = AddEleChar(c-EstablishmentInformation,"ItemXCustomer",string(emitente.item-cli))
           c-campo = AddEleChar(c-EstablishmentInformation,"Multi-PlantSummary",ENTRY(emitente.resumo-mp,{adinc/i04ad098.i 03})).

    FIND dist-emitente WHERE emitente.cod-emitente = dist-emitente.cod-emitente NO-LOCK NO-ERROR.
    IF  AVAIL dist-emitente THEN
        ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"UpdateBalanceCancelBonus",entry(dist-emitente.ind-atua-bonif-canc-saldo,{diinc/i02di275.i 03}))
               c-campo = AddEleChar(c-EstablishmentInformation,"BonusOrderGenType",entry(dist-emitente.ind-geracao-ped-bonif,{diinc/i06di272.i 03}))
               c-campo = AddEleChar(c-EstablishmentInformation,"ControlsBonusOnSale",string(dist-emitente.log-bonif-junto-venda))
               c-campo = AddEleChar(c-EstablishmentInformation,"ReleaseSaleWithoutBonus",string(dist-emitente.log-libera-venda-sem-bonif))
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoChar1",dist-emitente.char-1)
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoChar2",dist-emitente.char-2)
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoLog1",string(dist-emitente.log-1))
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoLog2",string(dist-emitente.log-2))
               c-campo = AddEleDeci(c-EstablishmentInformation,"EmitenteDistribuicaoDec1",dist-emitente.dec-1)
               c-campo = AddEleDeci(c-EstablishmentInformation,"EmitenteDistribuicaoDec2",dist-emitente.dec-2)
               c-campo = AddEleInt(c-EstablishmentInformation,"EmitenteDistribuicaoInt1",dist-emitente.int-1)
               c-campo = AddEleInt(c-EstablishmentInformation,"EmitenteDistribuicaoInt2",dist-emitente.int-2)
               c-campo = AddEleDate(c-EstablishmentInformation,"EmitenteDistribuicaoData1",dist-emitente.data-1,"")
               c-campo = AddEleDate(c-EstablishmentInformation,"EmitenteDistribuicaoData2",dist-emitente.data-2,"")
               c-campo = AddEleInt(c-EstablishmentInformation,"InvoicingCurr",dist-emitente.mo-fatur)   */
               /*c-campo = AddEleChar(c-EstablishmentInformation,"BonusInvafterTotal",string(dist-emitente.log-fatur-ped-bonif))
               c-campo = AddEleChar(c-EstablishmentInformation,"ExternalWhs",dist-emitente.cod-dep-ext)
               c-campo = AddEleChar(c-EstablishmentInformation,"DefaultWhs",dist-emitente.cod-dep-pad)
               c-campo = AddEleChar(c-EstablishmentInformation,"FreightTp",entry(dist-emitente.ind-tp-frete,{diinc/i01di315.i 03}))*/

    ASSIGN c-EstabRepresCollection       = AddElement(c-PartnerInformation,"EstablishmentRepresentativeCollection")
           c-EstablishmentRepresentative = AddElement(c-EstabRepresCollection,"EstablishmentRepresentative") 
               c-campo = AddEleInt(c-EstablishmentRepresentative,"Code",emitente.cod-rep).

END PROCEDURE.
         
PROCEDURE pi-CommunicationInformation-msg:
    
    DEF VAR c-CommunicationInformation AS CHAR NO-UNDO.
    
    ASSIGN c-CommunicationInformation = AddElement(c-PartnerInformation,"CommunicationInformation")
             c-campo = AddEleChar(c-CommunicationInformation,"URL",emitente.home-page)
             c-campo = AddEleChar(c-CommunicationInformation,"E-mail",emitente.e-mail)   
             c-campo = AddEleChar(c-CommunicationInformation,"Telephone1",emitente.telefone[1])   
             c-campo = AddEleChar(c-CommunicationInformation,"Ramal1",emitente.ramal[1])
             c-campo = AddEleChar(c-CommunicationInformation,"Telephone2",emitente.telefone[2])
             c-campo = AddEleChar(c-CommunicationInformation,"Ramal2",emitente.ramal[2])
             c-campo = AddEleChar(c-CommunicationInformation,"Fax1Number",emitente.telef-fac)
             c-campo = AddEleChar(c-CommunicationInformation,"Fax1ExtensionNumber",emitente.ramal-fac)
             c-campo = AddEleChar(c-CommunicationInformation,"Fax2Number",emitente.telefax)
             c-campo = AddElechar(c-CommunicationInformation,"Fax2ExtensionNumber",emitente.ramal-fax)
             c-campo = AddEleChar(c-CommunicationInformation,"Telex",emitente.telex)
             c-campo = ADDEleChar(c-CommunicationInformation,"ModemPhone",emitente.telef-modem)
             c-campo = AddEleChar(c-CommunicationInformation,"ModemExtensionNumber",emitente.ramal-modem)
             c-campo = AddEleInt(c-CommunicationInformation,"EDIPartner",emitente.cod-parceiro-edi).
END PROCEDURE.

PROCEDURE pi-TAXInformation-msg:
    
    DEF VAR c-TAXInformation AS CHAR NO-UNDO.

    ASSIGN c-TAXInformation = AddElement(c-PartnerInformation,"TAXInformation")
             c-campo = AddEleChar(c-TAXInformation,"Taxpayer",string(emitente.contrib-icms))
             c-campo = AddEleChar(c-TAXInformation,"RetentionAgent",string(emitente.agente-retencao))
             c-campo = AddEleChar(c-TAXInformation,"SUFRAMACode",emitente.cod-suframa)
             c-campo = AddEleChar(c-TAXInformation,"CACEXCode",emitente.cod-cacex)
             c-campo = AddEleChar(c-TAXInformation,"AuxiliaryNumberForTributarySubst",emitente.insc-subs-trib).
    &if defined (bf_dis_adm_preco) &then
    find first dist-emitente exclusive-lock where 
               dist-emitente.cod-emitente = emitente.cod-emitente  no-error.
         if avail dist-emitente then 
            ASSIGN c-campo = AddEleChar(c-TAXInformation,"TabeladePauta",dist-emitente.nr-tb-pauta).
    &else
        ASSIGN c-campo = AddEleChar(c-TAXInformation,"TabeladePauta",SUBSTR(emitente.char-1,1,5)).
    &endif

    ASSIGN   c-campo = AddEleInt(c-TAXInformation,"TaxExemptionCode",emitente.cod-isencao)
             c-campo = AddEleInt(c-TAXInformation,"TaxCode",emitente.cod-tax)
             c-campo = AddEleChar(c-TAXInformation,"SalesTaxPerception",string(emitente.percepcao)).

END PROCEDURE.

PROCEDURE pi-CreditInformation-msg:
    
    DEF VAR c-CreditInformation AS CHAR NO-UNDO.

    ASSIGN c-CreditInformation = AddElement(c-PartnerInformation,"CreditInformation")

             c-campo = AddEleChar(c-CreditInformation,"CreditIndicator",ENTRY(emitente.ind-cre-cli,{adinc/i10ad098.i 03}))
             c-campo = AddEleInt(c-CreditInformation,"CreditLimitCurrency",emitente.moeda-libcre)
             c-campo = AddEleChar(c-CreditInformation,"CreditEvaluation",ENTRY(emitente.ind-aval,{adinc/i09ad098.i 03}))
             c-campo = AddEleChar(c-CreditInformation,"ShipmentCreditEvaluation",ENTRY(emitente.ind-aval-embarque,{adinc/i09ad098.i 03}))
             c-campo = AddEleChar(c-CreditInformation,"EvaluationScope",entry(emitente.ind-abrange-aval,{adinc/i24ad098.i 03}))
             c-campo = AddEleChar(c-CreditInformation,"ReleaseInventoryWithoutReleaseCredit",string(emitente.ind-lib-estoque))
             c-campo = AddEleDeci(c-CreditInformation,"CreditLimit",emitente.lim-credit)
             c-campo = AddEleDate(c-CreditInformation,"CreditLimitDate",emitente.dt-lim-cred,"")
             c-campo = AddEleDeci(c-CreditInformation,"AdditionalCreditLimit",emitente.lim-adicional)
             c-campo = AddEleDate(c-CreditInformation,"AdditionalCreditLimitDate",emitente.dt-fim-cred,"")
             c-campo = AddEleChar(c-CreditInformation,"LastUpdateUser",emitente.user-libcre)
             c-campo = AddEleInt(c-CreditInformation,"LatePeriods",emitente.nr-peratr)
             c-campo = AddEleInt(c-CreditInformation,"InactiveMonths",emitente.nr-mesina)
             c-campo = AddEleInt(c-CreditInformation,"ReturnCheckMaxNumber",emitente.nr-cheque-devol)
             c-campo = AddEleDeci(c-CreditInformation,"ReturnCheckMaxAmount",emitente.vl-max-devol)
             c-campo = AddEleInt(c-CreditInformation,"ReturnedCheckPeriod",emitente.periodo-devol)
             c-campo = AddEleChar(c-CreditInformation,"ApproveCredit",string(emitente.ind-apr-cred)).
END PROCEDURE.

PROCEDURE pi-FinancialInformation-msg:

    DEF VAR c-FinancialInformation AS CHAR NO-UNDO.

    /* PCREQ-9042 - Portador do Emitente */
    assign i-portador    = emitente.portador
           i-modalidade  = emitente.modalidade
           i-port-prefer = emitente.port-prefer
           i-mod-prefer  = emitente.mod-prefer.

    if l-fn-port-emitente then do:

        run prgint/ufn/ufn008za.py persistent set h-api.
        if valid-handle(h-api) then do:
            empty temp-table tt_log_erro.
            run pi_busca_dados_portador_fin in h-api (input "",
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
                    log-manager:write-message("Portador do Cliente", "UFN008ZA":U).
                    log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
                    log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                    log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                end.
            end.
            empty temp-table tt_log_erro.
            run pi_busca_dados_portador_fin in h-api (input "",
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
                    log-manager:write-message("Portador Preferencial do Cliente", "UFN008ZA":U).
                    log-manager:write-message("C¢digo do Erro: ":U + string(tt_log_erro.ttv_num_cod_erro), "UFN008ZA":U).
                    log-manager:write-message("Mensagem......: ":U + tt_log_erro.ttv_des_msg_erro        , "UFN008ZA":U).
                    log-manager:write-message("Ajuda.........: ":U + tt_log_erro.ttv_des_msg_ajuda       , "UFN008ZA":U).
                end.
            end.
            delete procedure h-api.
        end.
    end.

    ASSIGN c-FinancialInformation = AddElement(c-PartnerInformation,"FinancialInformation")
             c-campo = AddEleInt(c-FinancialInformation,"Bank",emitente.cod-banco)           
             c-campo = AddEleChar(c-FinancialInformation,"Branch",emitente.agencia)
             c-campo = AddEleChar(c-FinancialInformation,"CheckingAccount",emitente.conta-corren)
             c-campo = AddEleInt(c-FinancialInformation,"BankInstructions1",emitente.ins-banc[1])
             c-campo = AddEleInt(c-FinancialInformation,"BankInstructions2",emitente.ins-banc[2])
             c-campo = AddEleInt(c-FinancialInformation,"Collect",i-portador)
             c-campo = AddEleInt(c-FinancialInformation,"PreferredCollect",i-port-prefer)
             c-campo = AddEleChar(c-FinancialInformation,"CollectorMode",entry(i-modalidade,{adinc/i03ad209.i 03})) 
             c-campo = AddEleChar(c-FinancialInformation,"PreferencialCollectorMode",entry(i-mod-prefer,{adinc/i03ad209.i 03})) 
             c-campo = AddEleChar(c-FinancialInformation,"PenaltyCalc",string(emitente.calcula-multa))
             c-campo = AddEleDate(c-FinancialInformation,"FinancialRateDate",emitente.data-taxa,"")
             c-campo = AddEleChar(c-FinancialInformation,"Statement",string(emitente.emite-bloq))
             c-campo = AddEleChar(c-FinancialInformation,"GenerateDebitMemo",string(emitente.gera-ad))
             c-campo = AddEleInt(c-FinancialInformation,"GeneratePriceDifference",emitente.gera-difer)
             c-campo = AddEleInt(c-FinancialInformation,"NumberOfDays",emitente.nr-dias)
             c-campo = AddEleInt(c-FinancialInformation,"NoOfDaysOverdue",emitente.nr-dias-atraso)
             c-campo = AddEleChar(c-FinancialInformation,"ReceiveInformationSCI",string(emitente.recebe-inf-sci))
             c-campo = AddEleDeci(c-FinancialInformation,"MinAmountForDebitMemoGen",emitente.vl-min-ad)
             c-campo = AddEleInt(c-FinancialInformation,"PaymentTerm",emitente.cod-cond-pag)
             c-campo = AddEleDeci(c-FinancialInformation,"MinimumAmount",emitente.valor-minimo).

END PROCEDURE.

PROCEDURE pi-VendorInformation-msg:

    DEF VAR c-VendorInformation AS CHAR NO-UNDO.

    ASSIGN c-VendorInformation = AddElement(c-PartnerInformation,"VendorInformation")
             c-campo = AddEleInt(c-VendorInformation,"VendorGroupCode",emitente.cod-gr-forn)
             c-campo = AddEleChar(c-VendorInformation,"VendorClassificationLevelCode",IF emitente.cod-classif-fornec <> 0                          
                                                                                      THEN ENTRY(emitente.cod-classif-fornec,{adinc/i29ad098.i 03})
                                                                                      ELSE "")                                
             c-campo = AddEleChar(c-VendorInformation,"PaymentStatus",entry(emitente.flag-pag,{adinc/i26ad098.i 03}))
             c-campo = AddEleChar(c-VendorInformation,"ExportationServices",string(emitente.forn-exp))
             c-campo = AddEleChar(c-VendorInformation,"Licensor",string(emitente.ind-licenciador))
             c-campo = AddEleDeci(c-VendorInformation,"PeriodPurchase",emitente.compr-period)
             c-campo = AddEleInt(c-VendorInformation,"NumberOfCopies",emitente.nr-copias-ped)
             c-campo = AddEleInt(c-VendorInformation,"StdRevenueCode",emitente.tp-desp-padrao)
             c-campo = AddEleChar(c-VendorInformation,"DueSunday",IF emitente.ven-domingo <> 0 
                                                                  THEN ENTRY(emitente.ven-domingo,{adinc/i17ad098.i 03})
                                                                  ELSE "")
             c-campo = AddEleChar(c-VendorInformation,"DueHoliday",IF emitente.ven-feriado <> 0 
                                                                   THEN ENTRY(emitente.ven-feriado,{adinc/i17ad098.i 03})
                                                                   ELSE "")
             c-campo = AddEleDeci(c-VendorInformation,"FinancialRate",emitente.taxa-financ)
             c-campo = AddEleInt(c-VendorInformation,"FinancialRateDays",emitente.nr-dias-taxa)
             c-campo = AddEleInt(c-VendorInformation,"ImportationRepresentative",emitente.cod-repres-imp)
             c-campo = AddEleChar(c-VendorInformation,"RetentionAuthority",ENTRY(emitente.ind-emit-retencao,{adinc/i28ad098.i 03}))
             c-campo = AddEleInt(c-VendorInformation,"NoDocuments",emitente.nr-titulo)
             c-campo = AddEleChar(c-VendorInformation,"Revenue",string(emitente.ind-rendiment))
             c-campo = AddEleInt(c-VendorInformation,"ClearanceDays",emitente.dias-comp)
             c-campo = AddEleChar(c-VendorInformation,"DueEqualFlowDate",string(emitente.vencto-dia-nao-util))
             c-campo = AddEleDeci(c-VendorInformation,"TaxableRevenue",emitente.rend-tribut)
             c-campo = AddEleInt(c-VendorInformation,"TaxProgressiveTableCode",emitente.nr-tab-progr)
             c-campo = AddEleChar(c-VendorInformation,"PaymentType",ENTRY(emitente.tp-pagto,{adinc/i22ad098.i 03})).
END PROCEDURE.

PROCEDURE pi-PartnerRoles-msg:
    DEF VAR c-EstablishmentRoles AS CHAR NO-UNDO.
    
    ASSIGN c-EstablishmentRoles = AddElement(c-PartnerInformation,"EstablishmentRoles")
             c-campo = AddEleChar(c-EstablishmentRoles,"Portal","FALSE")
             c-campo = AddEleChar(c-EstablishmentRoles,"Carrier","FALSE")
             c-campo = AddEleChar(c-EstablishmentRoles,"Customer",IF  emitente.identific = 1
                                                                  OR  emitente.identific = 3
                                                                  THEN "TRUE"
                                                                  ELSE "FALSE") /* Cliente/Ambos */
             c-campo = AddEleChar(c-EstablishmentRoles,"Supplier",IF  emitente.identific = 2
                                                                  OR  emitente.identific = 3
                                                                  THEN "TRUE"
                                                                  ELSE "FALSE") /* Fornecedor/Ambos */
             c-campo = AddEleChar(c-EstablishmentRoles,"PurchaseCentral","FALSE")
             c-campo = AddEleChar(c-EstablishmentRoles,"Distributor","FALSE")
             c-campo = AddEleChar(c-EstablishmentRoles,"Establishment","FALSE").
END PROCEDURE.

PROCEDURE pi-IdentificationCollection-msg:
    DEF VAR c-IdentificationCollection AS CHAR NO-UNDO.
    DEF VAR c-Identification           AS CHAR NO-UNDO.
    
    ASSIGN c-IdentificationCollection = AddElement(c-PartnerInformation,"EstablishmentIdentificationCollection")
             c-Identification = AddElement(c-IdentificationCollection,"EstablishmentIdentification")
               c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc)
               c-campo = AddEleChar(c-Identification,"IdentificationType",IF emitente.natureza = 1
                                                                          THEN "CPF"
                                                                          ELSE "CNPJ").
   /* IF  emitente.ins-estadual <> "" THEN
        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")     
                 c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-estadual)
                 c-campo = AddEleChar(c-Identification,"IdentificationType","Inscr.Est.") .

    IF  emitente.ins-municipal <> "" THEN
    ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")     
             c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-municipal)
             c-campo = AddEleChar(c-Identification,"IdentificationType","IM") .
     */
END PROCEDURE.

PROCEDURE pi-AddressCollection-msg:
    DEF VAR c-AddressCollection        AS CHAR NO-UNDO.
    DEF VAR c-IdentificationCollection AS CHAR NO-UNDO.
    DEF VAR c-Identification           AS CHAR NO-UNDO.
    DEF VAR c-Address                  AS CHAR NO-UNDO.

    ASSIGN c-AddressCollection          = AddElement(c-PartnerInformation,"EstablishmentAddressCollection").
             /* Tipo 2 - End Entrega */
    FOR EACH  loc-entr NO-LOCK
        WHERE loc-entr.nome-abrev = emitente.nome-abrev :

        ASSIGN c-Address = AddElement(c-AddressCollection,"EstablishmentAddress")
                c-campo = AddEleInt(c-Address,"AddressType",2) 
                c-Address = AddElement(c-Address,"Address")
                 c-campo = AddEleChar(c-Address,"AddressLine1",loc-entr.endereco) 
                 /*c-campo = AddEleChar(c-Address,"AddressLine2","") 
                 c-campo = AddEleChar(c-Address,"AddressLine3","") */
                 c-campo = AddEleChar(c-Address,"CityName",loc-entr.cidade) 
                 c-campo = AddEleChar(c-Address,"DistrictName",loc-entr.bairro) 
                 c-campo = AddEleChar(c-Address,"StateCode",loc-entr.estado) 
       /*          c-campo = AddEleChar(c-Address,"LegacyCountryCode",loc-entr.pais)  */
                 c-campo = AddEleChar(c-Address,"NationalPostalCode",loc-entr.cep). 
              /*   c-campo = AddEleChar(c-Address,"RegionName","") 
                 c-campo = AddEleChar(c-Address,"AddressCode",loc-entr.cod-entrega) 
                 c-campo = AddEleChar(c-Address,"POBox",loc-entr.caixa-postal)
                 c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")     
                   c-Identification = AddElement(c-IdentificationCollection,"Identification")
                     c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                                THEN "CPF"
                                                                                ELSE "CNPJ")
                     c-campo = AddEleChar(c-Identification,"IdentificationNumber",loc-entr.cgc).
                                                                                                   

        IF  emitente.ins-estadual <> "" THEN 
            ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                     c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                     c-campo = AddEleChar(c-Identification,"IdentificationNumber",loc-entr.ins-estadual).
                     */
    END.
             /* Tipo 3 - End Cobran‡a */
    ASSIGN c-Address = AddElement(c-AddressCollection,"EstablishmentAddress")
             c-campo = AddEleInt(c-Address,"AddressType",3)
             c-Address = AddElement(c-Address,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1",emitente.endereco-cob)
             c-campo = AddEleChar(c-Address,"AddressLine2","")
             c-campo = AddEleChar(c-Address,"AddressLine3","")
             c-campo = AddEleChar(c-Address,"CityName",emitente.cidade-cob)
             c-campo = AddEleChar(c-Address,"DistrictName",emitente.bairro-cob)
             c-campo = AddEleChar(c-Address,"StateCode",emitente.estado-cob)
        /*     c-campo = AddEleChar(c-Address,"LegacyCountryCode",emitente.pais-cob)*/
             c-campo = AddEleChar(c-Address,"NationalPostalCode",emitente.cep-cob).
            /* c-campo = AddEleChar(c-Address,"RegionName","")
             c-campo = AddEleChar(c-Address,"AddressCode","")
             c-campo = AddEleChar(c-Address,"POBox",emitente.cx-post-cob)
             c-campo = AddEleChar(c-Address,"ZipCode",emitente.zip-cob-code)
             c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
               c-Identification = AddElement(c-IdentificationCollection,"Identification")
                 c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                            THEN "CPF"
                                                                            ELSE "CNPJ")
                 c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc-cob).

    IF  emitente.ins-estadual <> "" THEN
        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                 c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                 c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-est-cob).
              */
    /* Tipo 8 - Endereco Principal */
    ASSIGN c-Address = AddElement(c-AddressCollection,"EstablishmentAddress")
             c-campo = AddEleInt(c-Address,"AddressType",8)
             c-Address = AddElement(c-Address,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1",emitente.endereco)
             c-campo = AddEleChar(c-Address,"AddressLine2",emitente.endereco2)
             c-campo = AddEleChar(c-Address,"AddressLine3","")
             c-campo = AddEleChar(c-Address,"CityName",emitente.cidade)
             c-campo = AddEleChar(c-Address,"DistrictName",emitente.bairro)
             c-campo = AddEleChar(c-Address,"StateCode",emitente.estado)
        /*     c-campo = AddEleChar(c-Address,"LegacyCountryCode",emitente.pais)*/
             c-campo = AddEleChar(c-Address,"NationalPostalCode",emitente.cep).
             /*c-campo = AddEleChar(c-Address,"RegionName","")
             c-campo = AddEleChar(c-Address,"AddressCode",emitente.cod-entrega)
             c-campo = AddEleChar(c-Address,"POBox",emitente.caixa-postal)
             c-campo = AddEleChar(c-Address,"ZipCode",emitente.zip-code)
             c-campo = AddEleChar(c-Address,"County",emitente.cn-codigo)
             c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
               c-Identification = AddElement(c-IdentificationCollection,"Identification")
                 c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                            THEN "CPF"
                                                                            ELSE "CNPJ")
                 c-campo = ADDELECHAR(c-Identification,"IdentificationNumber",emitente.cgc).

    IF  emitente.ins-estadual <> "" THEN
        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                 c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                 c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-estadual).

    IF  emitente.ins-municipal <> "" THEN
        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                 c-campo = AddEleChar(c-Identification,"IdentificationType","IM")
                 c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-municipal).
           */
END PROCEDURE.

PROCEDURE pi-ContactCollection-msg:
    DEF VAR c-ContactCollection  AS CHAR NO-UNDO.
    DEF VAR c-ContactInformation AS CHAR NO-UNDO.

    ASSIGN c-ContactCollection = AddElement(c-PartnerInformation,"EstablishmentContactCollection").
    FOR EACH cont-emit NO-LOCK
        WHERE cont-emit.cod-emitente = emitente.cod-emitente:
        ASSIGN  c-ContactInformation = AddElement(c-ContactCollection,"EstablishmentContact")     
                c-campo = AddEleChar(c-ContactInformation,"ContactType","12") 
                c-ContactInformation = AddElement(c-ContactInformation,"ContactInformation")     
                 c-campo = AddEleChar(c-ContactInformation,"ContactName",cont-emit.nome) 
                 c-campo = AddEleChar(c-ContactInformation,"TelephoneNumber",cont-emit.telefone)
                 c-campo = AddEleChar(c-ContactInformation,"EmailAddress",cont-emit.e-mail) .

        ASSIGN  c-ContactInformation = AddElement(c-ContactCollection,"EstablishmentContact")     
                c-campo = AddEleChar(c-ContactInformation,"ContactType","1") 
                c-ContactInformation = AddElement(c-ContactInformation,"ContactInformation")     
                 c-campo = AddEleChar(c-ContactInformation,"ContactName",cont-emit.nome) 
                 c-campo = AddEleChar(c-ContactInformation,"TelephoneNumber",cont-emit.telefone)
                 c-campo = AddEleChar(c-ContactInformation,"EmailAddress",cont-emit.e-mail) .

        ASSIGN  c-ContactInformation = AddElement(c-ContactCollection,"EstablishmentContact")     
                c-campo = AddEleChar(c-ContactInformation,"ContactType","2") 
                c-ContactInformation = AddElement(c-ContactInformation,"ContactInformation")     
                 c-campo = AddEleChar(c-ContactInformation,"ContactName",cont-emit.nome) 
                 c-campo = AddEleChar(c-ContactInformation,"TelephoneNumber",cont-emit.telefone)
                 c-campo = AddEleChar(c-ContactInformation,"EmailAddress",cont-emit.e-mail) .
    END.
END PROCEDURE.
                      
PROCEDURE pi-rodape-msg:
    DEF VAR c-Address            AS CHAR NO-UNDO.
    DEF VAR c-ContactInformation AS CHAR NO-UNDO.

    FIND FIRST estabelec WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
    IF  AVAIL estabelec THEN
        FIND FIRST empresa WHERE empresa.ep-codigo = estabelec.ep-codigo NO-LOCK NO-ERROR.

    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-ContactInformation = AddElement(c-FromRole,"ContactInformation")
             c-campo = AddEleChar(c-ContactInformation,"ContactName","")
             c-campo = AddEleChar(c-ContactInformation,"TelephoneNumber","")
             c-campo = AddEleChar(c-ContactInformation,"EmailAddress","")
           c-Address = AddElement(c-FromRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1",empresa.endereco) 
             c-campo = AddEleChar(c-Address,"AddressLine2",empresa.endereco-2) 
             c-campo = AddEleChar(c-Address,"AddressLine3","") 
             c-campo = AddEleChar(c-Address,"CityName",empresa.cidade) 
             c-campo = AddEleChar(c-Address,"DistrictName",empresa.bairro) 
             c-campo = AddEleChar(c-Address,"StateCode",empresa.uf) 
             c-campo = AddEleChar(c-Address,"LegacyCountryCode",empresa.pais) 
             c-campo = AddEleChar(c-Address,"NationalPostalCode",empresa.cep) 
             c-campo = AddEleChar(c-Address,"RegionName","") 
             c-campo = AddEleChar(c-Address,"AddressCode","")
             c-campo = AddEleChar(c-Address,"EmailAddress",""). 
    
    ASSIGN c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","")
           c-ContactInformation = AddElement(c-ToRole,"ContactInformation")
             c-campo = AddEleChar(c-ContactInformation,"ContactName","")
             c-campo = AddEleChar(c-ContactInformation,"TelephoneNumber","")
             c-campo = AddEleChar(c-ContactInformation,"EmailAddress","")
           c-Address = AddElement(c-ToRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1","") 
             c-campo = AddEleChar(c-Address,"AddressLine2","") 
             c-campo = AddEleChar(c-Address,"AddressLine3","") 
             c-campo = AddEleChar(c-Address,"CityName","") 
             c-campo = AddEleChar(c-Address,"DistrictName","") 
             c-campo = AddEleChar(c-Address,"StateCode","") 
             c-campo = AddEleChar(c-Address,"LegacyCountryCode","") 
             c-campo = AddEleChar(c-Address,"NationalPostalCode","") 
             c-campo = AddEleChar(c-Address,"RegionName","") 
             c-campo = AddEleChar(c-Address,"AddressCode",""). 
END PROCEDURE.
