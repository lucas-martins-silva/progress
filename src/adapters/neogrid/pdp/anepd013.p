/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD013 2.00.00.020 } /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd013 MAN}
&ENDIF

/******************************************************************************
**  Programa: anepd013.p 
**  Funcao  : Receiver de Clientes
**  Data    : 10/2002
**  Autor   : Liziane
******************************************************************************/

&IF int(entry(1,proversion,".")) >= 8 &THEN

DEF VAR h-api                     AS HANDLE  NO-UNDO.
DEF VAR r-rowid                   AS ROWID   NO-UNDO.
DEF VAR c-root                    AS CHAR    NO-UNDO.
DEF VAR c-docidentifier           AS CHAR    NO-UNDO.
DEF VAR c-message                 AS CHAR    NO-UNDO.
DEF VAR c-campo                   AS CHAR    NO-UNDO.
/*DEF VAR c-FromRole                AS CHAR    NO-UNDO.*/
DEF VAR c-ToRole                  AS CHAR    NO-UNDO.
DEF VAR c-cod-estabel             AS CHAR    NO-UNDO.
DEF VAR c-UpdatePartner           AS CHAR    NO-UNDO.
DEF VAR c-PartnerCollection       AS CHAR    NO-UNDO.
DEF VAR c-PartnerInformation      AS CHAR    NO-UNDO.
DEF VAR c-root-PartnerInformation AS CHAR    NO-UNDO.
DEF VAR c-tab-pauta               AS CHAR    NO-UNDO.
DEF VAR i-cod-emit-externo        AS INTEGER NO-UNDO.

DEF VAR i-emitente                LIKE emitente.cod-emitente NO-UNDO.

DEFINE VARIABLE c-Mensagem        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ErroEndereco    AS LOGICAL     NO-UNDO.

/* Declaraá∆o da funá∆o fn-valida-bairro-sped */
FUNCTION fn-valida-bairro-sped RETURNS CHAR (INPUT p-bairro AS CHAR) FORWARD.

FIND FIRST param-global NO-LOCK NO-ERROR.
/* Preprocessadores */
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

/* Funcoes para ler a mensagem XML */
{adapters/neogrid/include/anein005.i}

 /* Temp-Table tt-erro-neogrid */
{adapters/neogrid/ftp/aneft002.i}

{method/dbotterr.i}

{cdp/cdapi229.i2}  /* tt-emitente,
                     tt-loc-entr */
{cdp/cdapi300.i1} /* tt-versao-integr,
                     tt-erros-geral */
{cdp/cdapi237.i}  /* tt-cont-emit */

{utp/ut-glob.i}

ASSIGN c-cod-estabel = "".

/* PCREQ-9042 - Portador do Emitente */
define variable i-portador         as integer no-undo.
define variable i-modalidade       as integer no-undo.
define variable h-api-port-fin     as handle  no-undo.
define variable l-fn-port-emitente as logical no-undo.
def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   format ">>>>,>>9" label "Número"         column-label "Número"
    field ttv_des_msg_ajuda as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistºncia"
    .
{cdp/cdapi3009.i2}

/* Limpeza das temp-tables auxiliares na implantaá∆o */
RUN pi-limpa-tt.

RUN pi-cabecalho-msg.
RUN pi-corpo-msg.
/*RUN pi-rodape-msg.*/

IF  NOT VALID-HANDLE(h-api)
OR  h-api:TYPE <> "PROCEDURE":U
OR  h-api:FILE-NAME <> "cdp/cdapi271.p":U THEN
    RUN cdp/cdapi271.p PERSISTENT SET h-api.

/* Quando n∆o ocorrer problemas com transaá∆o dispon°vel para Cliente 
   pi-EstablishmentRoles-msg */
IF  NOT CAN-FIND (FIRST tt-erro-neogrid) THEN DO:
    /* Efetivaá∆o dos clientes/contatos no ERP */
    RUN GravaClientes.
    RUN GravaContatos.

    FIND FIRST tt-emitente NO-ERROR.
    IF  CAN-FIND (FIRST emitente
                  WHERE emitente.cod-emitente = tt-emitente.cod-emitente) 
    /*AND tt-emitente.ind-tipo-movto = 1*/ THEN DO:  /* sempre atualizar† o dist-emitente */
        /*&IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
        &ELSE*/
        RUN AtualizaDistEmitente.
        /*&ENDIF*/
        RUN ReenviaXML. /* Retorna XML quando implantado no ERP */
    END.
END.

/* Envia XML com mensagens de erros que retornaram da implantaá∆o */
IF  CAN-FIND (FIRST tt-erro-neogrid) THEN
    RUN adapters/neogrid/ftp/aneft052.p (INPUT TABLE tt-erro-neogrid).

IF  VALID-HANDLE(h-api) THEN DO:
    DELETE PROCEDURE h-api.
    ASSIGN h-api = ?.
END.

/*=================================== PROCEDIMENTOS INTERNOS =======================================*/

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = getRoot()
             c-docidentifier = Getsonval(c-root,"DocIdentifier")
             c-message = GET(c-root,"Message")
               c-UpdatePartner = GET(c-Message,"UpdatePartner")
                 c-PartnerCollection = GET(c-UpdatePartner,"PartnerCollection")
                   c-root-PartnerInformation = GetElements(c-PartnerCollection).
                 /*c-FromRole = GET(c-UpdatePartner,"FromRole")*/

    IF  AvailTag(c-UpdatePartner,"ToRole") THEN
        ASSIGN c-ToRole = GET(c-UpdatePartner,"ToRole")
                 c-cod-estabel = getsonval(c-ToRole,"LegacyLocationIdentifier").
END.

PROCEDURE pi-corpo-msg:
    DEF VAR i-cont-PartnerInformation AS INT NO-UNDO.

    DO  i-cont-PartnerInformation = 1 TO NUM-ENTRIES(c-root-PartnerInformation):
        ASSIGN c-PartnerInformation = ENTRY(i-cont-PartnerInformation,c-root-PartnerInformation).

        RUN pi-EstablishmentInformation-msg.
        RUN pi-CommunicationInformation-msg. /*GAP*/
        RUN pi-TAXInformation-msg. /*GAP*/
        RUN pi-CreditInformation-msg. /*GAP*/
        RUN pi-FinancialInformation-msg. /*GAP*/
        RUN pi-VendorInformation-msg. /*GAP*/
        RUN pi-EstablishmentRoles-msg.
        RUN pi-IdentificationCollection-msg.
        RUN pi-AddressCollection-msg.
        RUN pi-ContactCollection-msg.
    END.
END PROCEDURE.

PROCEDURE pi-EstablishmentInformation-msg:
    DEF VAR c-EstablishmentInformation AS CHAR NO-UNDO.
    DEF VAR c-CreditIndicator          AS CHAR NO-UNDO.
    DEF VAR c-PartialInvoicing         AS CHAR NO-UNDO.
    DEF VAR c-SalesOrderStdClassCode   AS CHAR NO-UNDO.
    DEF VAR c-Type                     AS CHAR NO-UNDO.
    DEF VAR c-ExpenseCollectCode       AS CHAR NO-UNDO.
    DEF VAR c-nome-repres              LIKE repres.nome-abrev.

    CREATE tt-emitente.

    ASSIGN c-EstablishmentInformation = Get(c-PartnerInformation,"EstablishmentInformation")
             tt-emitente.cod-emitente = INT(Getsonval(c-EstablishmentInformation,"InternalCode"))
             tt-emitente.nome-abrev   = Getsonval(c-EstablishmentInformation,"ShortName")
             i-cod-emit-externo       = INT(Getsonval(c-EstablishmentInformation,"EmitenteDistribuicaoInt1"))
             i-emitente               = 0.

    IF  tt-emitente.cod-emitente = 0 THEN DO: /* cod-emitente = 0 significa Inclusao de novo cliente */
        /*Se ja existe um nome-abrev cadastrado */
        FIND emitente WHERE emitente.nome-abrev = tt-emitente.nome-abrev NO-LOCK NO-ERROR.
        IF  AVAIL emitente THEN DO:
            FIND FIRST dist-emitente 
                 WHERE dist-emitente.cod-emitente = emitente.cod-emitente
                 AND   dist-emitente.int-1        = i-cod-emit-externo
                 NO-LOCK NO-ERROR. /* j† existe com o numero vindo do CRM */

            IF  AVAIL dist-emitente THEN DO:
                BUFFER-COPY emitente TO tt-emitente.
                /* Modificacao */ /* Nesta situacao apenas nao houve retorno ao CRM da inclusao do cliente no ERP */
                ASSIGN tt-emitente.ind-tipo-movto = 2
                       i-emitente                 = emitente.cod-emitente.
            END.
            ELSE
                /* Inclusao */ /* Nesta situacao a api dar† erro de nome abrev j† existente */
                ASSIGN tt-emitente.ind-tipo-movto = 1.
        END.
        ELSE
            ASSIGN tt-emitente.ind-tipo-movto = 1.  /* Inclusao */
    END.
    ELSE DO:
        FIND emitente WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.
        IF  AVAIL emitente THEN DO:
            BUFFER-COPY emitente TO tt-emitente.
            ASSIGN tt-emitente.ind-tipo-movto = 2  /* Modificacao */
                   i-emitente                 = emitente.cod-emitente.
        END.
        ELSE 
            ASSIGN tt-emitente.ind-tipo-movto = 1.  /* Inclusao */
    END.

    IF  tt-emitente.ind-tipo-movto = 1 THEN
        ASSIGN tt-emitente.identific = 1.  /* Cliente */

    ASSIGN tt-emitente.nome-emit    = Getsonval(c-EstablishmentInformation,"LegalName")
           tt-emitente.bonificacao  = DEC(Getsondec(c-EstablishmentInformation,"Discount"))
           tt-emitente.nome-matriz  = Getsonval(c-EstablishmentInformation,"HoldingCompany")  /*GAP*/
           tt-emitente.cod-gr-cli   = INT(Getsonval(c-EstablishmentInformation,"CustomerGroup"))
           tt-emitente.atividade    = Getsonval(c-EstablishmentInformation,"MarketActivity")
           tt-emitente.categoria    = Getsonval(c-EstablishmentInformation,"Category")  /*GAP*/
           tt-emitente.linha-produt = Getsonval(c-EstablishmentInformation,"ProductLine").  /*GAP*/
             
    IF  AvailTag(c-EstablishmentInformation,"RepresentativeCode") THEN
        ASSIGN tt-emitente.cod-rep = INT(Getsonval(c-EstablishmentInformation,"RepresentativeCode")).
    ELSE DO:
        ASSIGN c-nome-repres = Getsonval(c-EstablishmentInformation,"Representative").

        FIND repres WHERE repres.nome-abrev = c-nome-repres NO-LOCK NO-ERROR.
        IF  AVAIL repres THEN
            ASSIGN tt-emitente.cod-rep = repres.cod-rep.
    END.

    ASSIGN tt-emitente.nome-mic-reg    = Getsonval(c-EstablishmentInformation,"MicroTerritory")
           tt-emitente.cod-transp      = INT(Getsonval(c-EstablishmentInformation,"Carrier"))
           tt-emitente.nome-tr-red     = IF  AvailTag(c-EstablishmentInformation,"ReshipmentCarrier")
                                         THEN Getsonval(c-EstablishmentInformation,"ReshipmentCarrier")
                                         ELSE tt-emitente.nome-tr-red
           tt-emitente.data-implant    = GetsonDate(c-EstablishmentInformation,"RegisterDate")
           tt-emitente.nat-operacao    = Getsonval(c-EstablishmentInformation,"TransactionType")  /*GAP*/
           tt-emitente.nat-ope-ext     = Getsonval(c-EstablishmentInformation,"InterstateTransactionType")  /*GAP*/
           tt-emitente.tp-rec-padrao   = IF  Getsonval(c-EstablishmentInformation,"StdRevenueCode") = ""
                                         THEN 0
                                         ELSE INT(Getsonval(c-EstablishmentInformation,"StdRevenueCode"))  /*GAP*/
           c-ExpenseCollectCode        = Getsonval(c-EstablishmentInformation,"ExpenseCollectCode")  /*GAP*/
           tt-emitente.tip-cob-desp    = IF  {diinc/i04di072.i 06 c-ExpenseCollectCode} > 0
                                         THEN {diinc/i04di072.i 06 c-ExpenseCollectCode}
                                         ELSE tt-emitente.tip-cob-desp
           tt-emitente.cod-canal-venda = IF  Getsonval(c-EstablishmentInformation,"DistributionChannelCode") = ""
                                         THEN 0
                                         ELSE INT(Getsonval(c-EstablishmentInformation,"DistributionChannelCode"))  /*GAP*/
           tt-emitente.nr-tabpre       = Getsonval(c-EstablishmentInformation,"PriceTable")  /*GAP*/
           c-SalesOrderStdClassCode    = Getsonval(c-EstablishmentInformation,"SalesOrderStdClassCode")  /*GAP*/
           tt-emitente.esp-pd-venda    = IF  {adinc/i06ad098.i 06 c-SalesOrderStdClassCode} > 0
                                         THEN {adinc/i06ad098.i 06 c-SalesOrderStdClassCode}
                                         ELSE tt-emitente.esp-pd-venda
           c-PartialInvoicing          = IF  Getsonval(c-EstablishmentInformation,"PartialInvoicing") = ""
                                         THEN "yes"
                                         ELSE Getsonval(c-EstablishmentInformation,"PartialInvoicing")  /*GAP*/
           tt-emitente.ind-fat-par     = IF  c-PartialInvoicing = "yes"
                                         THEN YES
                                         ELSE NO
           tt-emitente.per-minfat      = DEC(Getsondec(c-EstablishmentInformation,"PartialInvoicingMin"))  /*GAP*/
           tt-emitente.per-max-canc    = DEC(Getsondec(c-EstablishmentInformation,"BalanceCancMax"))  /*GAP*/
           tt-emitente.perc-fat-ped    = IF  Getsonval(c-EstablishmentInformation,"OrderInvoicingMax") = ""
                                         THEN 0
                                         ELSE INT(Getsonval(c-EstablishmentInformation,"OrderInvoicingMax"))  /*GAP*/
           c-Type                      = Getsonval(c-EstablishmentInformation,"Type")
           tt-emitente.natureza        = IF  {adinc/i03ad098.i 06 c-Type} > 0
                                         THEN {adinc/i03ad098.i 06 c-Type}
                                         ELSE tt-emitente.natureza
           tt-emitente.observacoes     = Getsonval(c-EstablishmentInformation,"Comments")
           tt-emitente.end-cobranca    = INT(Getsonval(c-EstablishmentInformation,"Bill-toAddressCode")) /*GAP*/
           tt-emitente.emite-etiq      = IF  Getsonval(c-EstablishmentInformation,"PrintLabel") = "Yes"
                                         THEN YES
                                         ELSE NO.

    IF  tt-emitente.data-implant = ? THEN
        ASSIGN tt-emitente.data-implant = TODAY.
END PROCEDURE.

PROCEDURE pi-CommunicationInformation-msg:
    DEF VAR c-CommunicationInformation AS CHAR NO-UNDO.

    ASSIGN c-CommunicationInformation     = Get(c-PartnerInformation,"CommunicationInformation")
             tt-emitente.home-page        = Getsonval(c-CommunicationInformation,"URL")
             tt-emitente.e-mail           = Getsonval(c-CommunicationInformation,"E-mail")
             tt-emitente.telefone[1]      = Getsonval(c-CommunicationInformation,"Telephone1")
             tt-emitente.ramal[1]         = Getsonval(c-CommunicationInformation,"Ramal1")
             tt-emitente.telefone[2]      = Getsonval(c-CommunicationInformation,"Telephone2")
             tt-emitente.ramal[2]         = Getsonval(c-CommunicationInformation,"Ramal2")
             tt-emitente.telef-fac        = Getsonval(c-CommunicationInformation,"Fax1Number")
             tt-emitente.ramal-fac        = Getsonval(c-CommunicationInformation,"Fax1ExtensionNumber")
             tt-emitente.telefax          = Getsonval(c-CommunicationInformation,"Fax2Number")
             tt-emitente.ramal-fax        = Getsonval(c-CommunicationInformation,"Fax2ExtensionNumber")
             tt-emitente.telex            = Getsonval(c-CommunicationInformation,"Telex")
             tt-emitente.telef-modem      = Getsonval(c-CommunicationInformation,"ModemPhone")
             tt-emitente.ramal-modem      = Getsonval(c-CommunicationInformation,"ModemExtensionNumber")
             tt-emitente.cod-parceiro-edi = IF  Getsonval(c-CommunicationInformation,"EDIPartner") = ""
                                            THEN 0
                                            ELSE INT(Getsonval(c-CommunicationInformation,"EDIPartner")).
END PROCEDURE.

PROCEDURE pi-TAXInformation-msg:
    DEF VAR c-TAXInformation AS CHAR NO-UNDO.
    DEF VAR c-RetentionAgent AS CHAR NO-UNDO.

    ASSIGN c-TAXInformation              = Get(c-PartnerInformation,"TAXInformation")
             tt-emitente.contrib-icms    = IF  Getsonval(c-TAXInformation,"Taxpayer") = "No"
                                           THEN NO
                                           ELSE YES
             tt-emitente.agente-retencao = IF  Getsonval(c-TAXInformation,"RetentionAgent") = "Yes"
                                           THEN YES
                                           ELSE NO
             tt-emitente.cod-suframa     = Getsonval(c-TAXInformation,"SUFRAMACode")
             tt-emitente.cod-cacex       = Getsonval(c-TAXInformation,"CACEXCode")
             tt-emitente.insc-subs-trib  = Getsonval(c-TAXInformation,"AuxiliaryNumberForTributarySubst")
             c-tab-pauta                 = Getsonval(c-TAXInformation,"TabeladePauta").
END PROCEDURE.

PROCEDURE pi-CreditInformation-msg:
    DEF VAR c-CreditInformation        AS CHAR NO-UNDO.
    DEF VAR c-CreditIndicator          AS CHAR NO-UNDO.
    DEF VAR c-ind-lib-estoque          AS CHAR NO-UNDO.
    DEF VAR c-CreditEvaluation         AS CHAR NO-UNDO.
    DEF VAR c-ShipmentCreditEvaluation AS CHAR NO-UNDO.
    DEF VAR c-EvaluationScope          AS CHAR NO-UNDO.

    ASSIGN c-CreditInformation = Get(c-PartnerInformation,"CreditInformation")
             c-CreditIndicator = Getsonval(c-CreditInformation,"CreditIndicator")
               tt-emitente.ind-cre-cli        = IF  {adinc/i10ad098.i 06 c-CreditIndicator} > 0
                                                THEN {adinc/i10ad098.i 06 c-CreditIndicator}
                                                ELSE tt-emitente.ind-cre-cli
               tt-emitente.moeda-libcre       = IF  Getsonval(c-CreditInformation,"CreditLimitCurrency") <> ""
                                                THEN INT(Getsonval(c-CreditInformation,"CreditLimitCurrency"))
                                                ELSE tt-emitente.moeda-libcre
             c-CreditEvaluation               = Getsonval(c-CreditInformation,"CreditEvaluation")
               tt-emitente.ind-aval           = IF  {adinc/i09ad098.i 06 c-CreditEvaluation} > 0
                                                THEN {adinc/i09ad098.i 06 c-CreditEvaluation}
                                                ELSE tt-emitente.ind-aval
             c-ShipmentCreditEvaluation       = Getsonval(c-CreditInformation,"ShipmentCreditEvaluation")
               tt-emitente.ind-aval-embarque  = IF  {adinc/i09ad098.i 06 c-ShipmentCreditEvaluation} > 0
                                                THEN {adinc/i09ad098.i 06 c-ShipmentCreditEvaluation}
                                                ELSE tt-emitente.ind-aval-embarque
             c-EvaluationScope                = Getsonval(c-CreditInformation,"EvaluationScope")
               tt-emitente.ind-abrange-aval   = IF  {adinc/i24ad098.i 06 c-EvaluationScope} > 0
                                                THEN {adinc/i24ad098.i 06 c-EvaluationScope}
                                                ELSE tt-emitente.ind-abrange-aval
             c-ind-lib-estoque                = Getsonval(c-CreditInformation,"ReleaseInventoryWithoutReleaseCredit")
               tt-emitente.ind-lib-estoque    = IF  c-ind-lib-estoque <> ""
                                                THEN IF  c-ind-lib-estoque = "yes"
                                                     THEN YES
                                                     ELSE NO
                                                ELSE tt-emitente.ind-lib-estoque
               tt-emitente.lim-credit         = IF  Getsonval(c-CreditInformation,"CreditLimit") <> ""
                                                THEN DEC(Getsonval(c-CreditInformation,"CreditLimit"))
                                                ELSE tt-emitente.lim-credit
               tt-emitente.dt-lim-cred        = IF  Getsonval(c-CreditInformation,"CreditLimitDate") <> ""
                                                THEN Getsondate(c-CreditInformation,"CreditLimitDate")
                                                ELSE tt-emitente.dt-lim-cred
               tt-emitente.lim-adicional      = IF  Getsonval(c-CreditInformation,"AdditionalCreditLimit") <> ""
                                                THEN DEC(Getsonval(c-CreditInformation,"AdditionalCreditLimit"))
                                                ELSE tt-emitente.lim-adicional
               tt-emitente.dt-fim-cred        = IF  Getsonval(c-CreditInformation,"AdditionalCreditLimitDate") <> ""
                                                THEN Getsondate(c-CreditInformation,"AdditionalCreditLimitDate")
                                                ELSE tt-emitente.dt-fim-cred
               tt-emitente.user-libcre        = Getsonval(c-CreditInformation,"LastUpdateUser")
               tt-emitente.nr-peratr          = IF  Getsonval(c-CreditInformation,"LatePeriods") <> ""
                                                THEN INT(Getsonval(c-CreditInformation,"LatePeriods"))
                                                ELSE tt-emitente.nr-peratr
               tt-emitente.nr-mesina          = IF  Getsonval(c-CreditInformation,"InactiveMonths") <> ""
                                                THEN INT(Getsonval(c-CreditInformation,"InactiveMonths"))
                                                ELSE tt-emitente.nr-mesina
               tt-emitente.nr-cheque-devol    = IF  Getsonval(c-CreditInformation,"ReturnCheckMaxNumber") <> ""
                                                THEN INT(Getsonval(c-CreditInformation,"ReturnCheckMaxNumber"))
                                                ELSE tt-emitente.nr-cheque-devol
               tt-emitente.vl-max-devol       = IF  Getsonval(c-CreditInformation,"ReturnCheckMaxAmount") <> ""
                                                THEN DEC(Getsonval(c-CreditInformation,"ReturnCheckMaxAmount"))
                                                ELSE tt-emitente.vl-max-devol
               tt-emitente.periodo-devol      = IF  Getsonval(c-CreditInformation,"ReturnedCheckPeriod") <> ""
                                                THEN INT(Getsonval(c-CreditInformation,"ReturnedCheckPeriod"))
                                                ELSE tt-emitente.periodo-devol.

	&IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
		/**********************************************************
		Se o m¢dulo de avaliaá∆o de crÇdito n∆o estiver implantado, 
		o crÇdito do cliente deve ser AUTOMµTICO.
		**********************************************************/
		FIND FIRST param-global NO-LOCK NO-ERROR.
		IF  AVAIL param-global AND NOT param-global.log-modul-cm THEN
			ASSIGN tt-emitente.ind-cre-cli       = 2
				   tt-emitente.ind-aval          = 1
				   tt-emitente.ind-aval-embarque = 1
				   tt-emitente.lim-credito       = 0
				   tt-emitente.dt-lim-cred       = ?.
	&ENDIF
            
END PROCEDURE.

PROCEDURE pi-FinancialInformation-msg:
    DEF VAR c-FinancialInformation AS CHAR NO-UNDO.

    ASSIGN c-FinancialInformation       = Get(c-PartnerInformation,"FinancialInformation")
             tt-emitente.cod-cond-pag   = IF  Getsonval(c-FinancialInformation,"PaymentTerm") = ""
                                          THEN 0
                                          ELSE INT(Getsonval(c-FinancialInformation,"PaymentTerm")).
END PROCEDURE.

PROCEDURE pi-VendorInformation-msg:
    DEF VAR c-VendorInformation AS CHAR NO-UNDO.

    IF  Availtag(c-PartnerInformation,"VendorInformation") THEN DO:
        ASSIGN c-VendorInformation = Get(c-PartnerInformation,"VendorInformation").
         IF  INT(Getsonval(c-VendorInformation,"StdRevenueCode")) <> 0 THEN
            ASSIGN tt-emitente.tp-desp-padrao = INT(Getsonval(c-VendorInformation,"StdRevenueCode")).
    END.

END PROCEDURE.

PROCEDURE pi-EstablishmentRoles-msg:
    DEF VAR c-EstablishmentRoles AS CHAR NO-UNDO.
    DEF VAR c-Customer           AS CHAR NO-UNDO.

    ASSIGN c-EstablishmentRoles = Get(c-PartnerInformation,"EstablishmentRoles")
             c-campo = Getsonval(c-EstablishmentRoles,"Portal") 
             c-campo = Getsonval(c-EstablishmentRoles,"Carrier")   
             c-Customer = Getsonval(c-EstablishmentRoles,"Customer")
             c-campo = Getsonval(c-EstablishmentRoles,"Supplier")
             c-campo = Getsonval(c-EstablishmentRoles,"PurchaseCentral")   
             c-campo = Getsonval(c-EstablishmentRoles,"Distributor")   
             c-campo = Getsonval(c-EstablishmentRoles,"Establishment").

    /* Quando retorna FALSE, Ç porque n∆o se trata de um cliente, logo descarta-se o XML */
    IF  c-Customer = "FALSE" THEN DO:
        {utp/ut-liter.i "Transacao Disponivel somente para Cliente" * r}
        CREATE tt-erro-neogrid.
        ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
               tt-erro-neogrid.c-cod-estabel = c-cod-estabel
               tt-erro-neogrid.i-cod-erro    = 1
               tt-erro-neogrid.c-desc-erro   = return-value.
    END.
END PROCEDURE.

PROCEDURE pi-IdentificationCollection-msg:
    DEF VAR c-IdentificationCollection AS CHAR NO-UNDO.
    DEF VAR c-Identification           AS CHAR NO-UNDO.
    DEF VAR c-root-Identification      AS CHAR NO-UNDO.
    DEF VAR i-cont-Identification      AS INT  NO-UNDO.
    DEF VAR c-IdentificationType       AS CHAR NO-UNDO.

    ASSIGN c-IdentificationCollection = Get(c-PartnerInformation,"IdentificationCollection")
             c-root-Identification    = GetElements(c-IdentificationCollection).

    DO  i-cont-Identification = 1 TO NUM-ENTRIES(c-root-Identification):
        ASSIGN c-Identification = ENTRY(i-cont-Identification,c-root-Identification)
                 c-campo              = Getsonval(c-Identification,"IdentificationType")
                 c-IdentificationType = Getsonval(c-Identification,"IdentificationType").

        CASE c-IdentificationType:
            WHEN "CPF"  THEN ASSIGN tt-emitente.cgc           = Getsonval(c-Identification,"IdentificationNumber").
            WHEN "CNPJ" THEN ASSIGN tt-emitente.cgc           = Getsonval(c-Identification,"IdentificationNumber").
            WHEN "IE"   THEN ASSIGN tt-emitente.ins-estadual  = Getsonval(c-Identification,"IdentificationNumber").
            WHEN "IM"   THEN ASSIGN tt-emitente.ins-municipal = Getsonval(c-Identification,"IdentificationNumber").
        END CASE.
    END.
END PROCEDURE.

PROCEDURE pi-AddressCollection-msg:
    DEF VAR c-AddressCollection        AS CHAR NO-UNDO.
    DEF VAR c-IdentificationCollection AS CHAR NO-UNDO.
    DEF VAR c-Identification           AS CHAR NO-UNDO.
    DEF VAR c-Address                  AS CHAR NO-UNDO.
    DEF VAR c-Address2                 AS CHAR NO-UNDO.
    DEF VAR c-Address3                 AS CHAR NO-UNDO.
    DEF VAR c-Address8                 AS CHAR NO-UNDO.
    DEF VAR c-root-Address             AS CHAR NO-UNDO.
    DEF VAR i-cont-Address             AS INT  NO-UNDO.
    DEF VAR c-root-Identification      AS CHAR NO-UNDO.
    DEF VAR i-cont-Identification      AS INT  NO-UNDO.
    DEF VAR c-IdentificationType       AS CHAR NO-UNDO.
    DEF VAR l-funcao-endereco-crm-padrao AS LOGICAL NO-UNDO.

    ASSIGN l-funcao-endereco-crm-padrao = can-find(first funcao
                                                   where funcao.cd-funcao = "spp-endereco-crm-padrao"
                                                   and   funcao.ativo).

    ASSIGN c-AddressCollection = Get(c-PartnerInformation,"AddressCollection")
             c-root-Address    = GetElements(c-AddressCollection)
             c-Address         = Get(c-AddressCollection,"Address").

    DO  i-cont-Address = 1 TO NUM-ENTRIES(c-root-Address):
        ASSIGN c-Address = ENTRY(i-cont-Address,c-root-Address).

        /* Tipo 2 - End Entrega */ 
        IF  INT(getsonval(c-Address,"AddressType")) = 2 THEN DO:
            CREATE tt-loc-entr.
            ASSIGN tt-loc-entr.endereco    = Getsonval(c-Address,"AddressLine1") 
                   tt-loc-entr.cidade      = Getsonval(c-Address,"CityName") 
                   tt-loc-entr.bairro      = fn-valida-bairro-sped(Getsonval(c-Address,"DistrictName"))
                   tt-loc-entr.estado      = Getsonval(c-Address,"StateCode") 
                   tt-loc-entr.pais        = Getsonval(c-Address,"LegacyCountryCode") 
                   tt-loc-entr.cep         = Getsonval(c-Address,"NationalPostalCode")
                   tt-loc-entr.cod-entrega = Getsonval(c-Address,"AddressCode")
                   tt-loc-entr.nome-abrev  = tt-emitente.nome-abrev.

            ASSIGN c-IdentificationCollection = Get(c-Address,"IdentificationCollection")
                     c-root-Identification    = GetElements(c-IdentificationCollection).

            DO  i-cont-Identification = 1 TO NUM-ENTRIES(c-root-Identification):
                ASSIGN c-Identification = ENTRY(i-cont-Identification,c-root-Identification)
                         c-IdentificationType = Getsonval(c-Identification,"IdentificationType").

                IF  c-IdentificationType = "CNPJ"
                OR  c-IdentificationType = "CPF" THEN
                    ASSIGN tt-loc-entr.cgc = Getsonval(c-Identification,"IdentificationNumber").
                ELSE
                    IF  c-IdentificationType = "IE" THEN
                        ASSIGN tt-loc-entr.ins-estadual = Getsonval(c-Identification,"IdentificationNumber").
            END.
        END.

        /* Tipo 3 - End Cobranáa */
        IF  INT(getsonval(c-Address,"AddressType"))  = 3 THEN DO:
            ASSIGN tt-emitente.endereco-cob = Getsonval(c-Address,"AddressLine1") 
                   tt-emitente.cidade-cob   = Getsonval(c-Address,"CityName") 
                   tt-emitente.bairro-cob   = fn-valida-bairro-sped(Getsonval(c-Address,"DistrictName"))
                   tt-emitente.estado-cob   = Getsonval(c-Address,"StateCode")
                   tt-emitente.pais-cob     = Getsonval(c-Address,"LegacyCountryCode")
                   tt-emitente.cep-cob      = Getsonval(c-Address,"NationalPostalCode").

            ASSIGN c-IdentificationCollection = Get(c-Address,"IdentificationCollection")
                     c-root-Identification    = GetElements(c-IdentificationCollection).

            DO  i-cont-Identification = 1 TO NUM-ENTRIES(c-root-Identification):
                ASSIGN c-Identification = ENTRY(i-cont-Identification,c-root-Identification)
                         c-IdentificationType = Getsonval(c-Identification,"IdentificationType").

                IF  c-IdentificationType = "CNPJ"
                OR  c-IdentificationType = "CPF" THEN
                    ASSIGN tt-emitente.cgc-cob     = Getsonval(c-Identification,"IdentificationNumber").
                ELSE
                    IF  c-IdentificationType = "IE" THEN
                        ASSIGN tt-emitente.ins-est-cob = Getsonval(c-Identification,"IdentificationNumber").
            END.
        END.

        /* Tipo 8 - Endereco Principal */
        IF  INT(getsonval(c-Address,"AddressType"))  = 8 THEN DO:
            ASSIGN tt-emitente.endereco    = Getsonval(c-Address,"AddressLine1") 
                   tt-emitente.cidade      = Getsonval(c-Address,"CityName") 
                   tt-emitente.bairro      = fn-valida-bairro-sped(Getsonval(c-Address,"DistrictName"))
                   tt-emitente.estado      = Getsonval(c-Address,"StateCode")
                   tt-emitente.pais        = Getsonval(c-Address,"LegacyCountryCode")
                   tt-emitente.cep         = Getsonval(c-Address,"NationalPostalCode")
                   tt-emitente.cod-entrega = IF l-funcao-endereco-crm-padrao THEN Getsonval(c-Address,"AddressCode")
                                                                             ELSE "Padr∆o".

            /****************************** Validaá∆o do Endereáo *******************************/
            /************************************************************************************/
            /************************************* ATENÄ«O **************************************/
            /************************************************************************************/
            /*** Esta validaá∆o Ç a mesma encontrada no programa cd0704, para tanto se houver ***/
            /*** alguma alteraá∆o no mesmo que altere alguma condiá∆o da validaá∆o, esta      ***/
            /*** tambÇm dever† ser atualizada para este programa (anepd013a.p), n∆o deixando  ***/
            /*** de lado o foco principal deste programa.                                     ***/
            /************************************************************************************/
            run adapters/neogrid/pdp/anepd013a.p (input tt-emitente.endereco,
                                                  input tt-emitente.pais,
                                                  output c-Mensagem,
                                                  output l-ErroEndereco).

            if l-ErroEndereco = yes then do:
                create tt-erro-neogrid.
                assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
                       tt-erro-neogrid.c-cod-estabel = c-cod-estabel
                       tt-erro-neogrid.i-cod-erro    = 17006
                       tt-erro-neogrid.c-desc-erro   = c-mensagem.
            end.
            /************************************************************************************/

            /* J† lidas as tag's mais acima
            ASSIGN c-IdentificationCollection = Get(c-Address,"IdentificationCollection")
                     c-root-Identification    = GetElements(c-IdentificationCollection).

            DO  i-cont-Identification = 1 TO NUM-ENTRIES(c-root-Identification):
                ASSIGN c-Identification       = ENTRY(i-cont-Identification,c-root-Identification)
                         c-IdentificationType = Getsonval(c-Identification,"IdentificationType").

                CASE c-IdentificationType:
                    WHEN "CPF"  THEN ASSIGN tt-emitente.cgc           = Getsonval(c-Identification,"IdentificationNumber").
                    WHEN "CNPJ" THEN ASSIGN tt-emitente.cgc           = Getsonval(c-Identification,"IdentificationNumber").
                    WHEN "IE"   THEN ASSIGN tt-emitente.ins-estadual  = Getsonval(c-Identification,"IdentificationNumber").
                    WHEN "IM"   THEN ASSIGN tt-emitente.ins-municipal = Getsonval(c-Identification,"IdentificationNumber").
                END CASE.
            END.*/
        END.
    END. /* fim DO i-cont-Address */
END PROCEDURE.

PROCEDURE pi-ContactCollection-msg:
    DEF VAR c-ContactCollection  AS CHAR NO-UNDO.
    DEF VAR c-ContactInformation AS CHAR NO-UNDO.
    DEF VAR c-root-Contact       AS CHAR NO-UNDO.
    DEF VAR i-cont-Contact       AS INT  NO-UNDO.
    DEF VAR i-cont               AS INT  NO-UNDO.
    DEF VAR i-nr-contatos        AS INT  NO-UNDO.
    DEF VAR l-sequence           AS LOG  NO-UNDO.
    DEF VAR c-nome               LIKE cont-emit.nome.
    DEF VAR c-char-aux1          AS CHAR NO-UNDO.
    DEF VAR c-char-aux2          AS CHAR NO-UNDO.
    DEF VAR c-char-aux3          AS CHAR NO-UNDO.

    ASSIGN i-cont     = 10.

     IF  AvailTag(c-PartnerInformation,"ContactCollection") THEN DO:
        ASSIGN c-ContactCollection = Get(c-PartnerInformation,"ContactCollection")
                 c-root-Contact    = GetElements(c-ContactCollection).

        DO  i-cont-Contact = 1 TO NUM-ENTRIES(c-root-Contact):
           ASSIGN l-sequence    = NO
                  i-nr-contatos = 0.

           ASSIGN  c-ContactInformation   = ENTRY(i-cont-Contact,c-root-Contact)
                   c-nome   = Getsonval(c-ContactInformation,"ContactName").
           
           IF c-nome <> "" AND c-nome <> ? THEN DO:
            
                CREATE tt-cont-emit.
                ASSIGN tt-cont-emit.cod-emitente = tt-emitente.cod-emitente
                        tt-cont-emit.nome = c-nome.
               
                IF  AvailTag(c-ContactInformation,"Sequence") THEN
                    ASSIGN tt-cont-emit.sequencia = int(Getsonval(c-ContactInformation,"Sequence"))
                           l-sequence             = YES.
                ELSE DO:
                    SELECT COUNT(*) INTO i-nr-contatos FROM  cont-emit
                                                       WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                                                       AND   cont-emit.nome         = tt-cont-emit.nome.
               
                    IF  i-nr-contatos >= 2 THEN DO:

                        {utp/ut-liter.i "H† mais de um contato cadastrado com o nome "}
                        assign c-char-aux1 = return-value.
                        
                        {utp/ut-liter.i " para o cliente "}
                        assign c-char-aux2 = return-value.
                        
                        {utp/ut-liter.i ", sendo que n∆o foi passada a sequància que identifique qual o contato a ser manutenido."}
                        assign c-char-aux3 = return-value.


                        RUN utp/ut-msgs.p (INPUT 'msg':U,
                                           INPUT 25997,
                                           INPUT c-char-aux1 + tt-cont-emit.nome + c-char-aux2 + STRING(tt-cont-emit.cod-emitente) + c-char-aux3).
               
                        CREATE tt-erro-neogrid.
                        ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
                               tt-erro-neogrid.c-cod-estabel = c-cod-estabel
                               tt-erro-neogrid.i-cod-erro    = 25997
                               tt-erro-neogrid.c-desc-erro   = trim(return-value).
                    END.
                END.
               
                IF  l-sequence = YES THEN DO:
                    FIND cont-emit
                         WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                         AND   cont-emit.sequencia    = tt-cont-emit.sequencia
                         NO-LOCK NO-ERROR.
               
                    ASSIGN tt-cont-emit.ind-tipo-movto = IF  AVAIL cont-emit
                                                         THEN 2   /*Modificaá∆o*/
                                                         ELSE 1.  /*Inclus∆o*/
                END.
                ELSE DO:
                    IF  i-nr-contatos = 0
                    AND l-sequence    = NO THEN DO:
                        FIND cont-emit
                             WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                             AND   cont-emit.sequencia    = i-cont
                             NO-LOCK NO-ERROR.
               
                        IF  AVAIL cont-emit THEN DO:
                            FIND LAST cont-emit WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente NO-LOCK NO-ERROR.
                            ASSIGN i-cont = cont-emit.sequencia + 10.
                        END.
               
                        ASSIGN tt-cont-emit.sequencia      = i-cont
                               tt-cont-emit.ind-tipo-movto = 1.  /*Inclus∆o*/
                    END.
               
                    IF  i-nr-contatos = 1 THEN DO:
                        FIND FIRST cont-emit
                             WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                             AND   cont-emit.nome         = tt-cont-emit.nome
                             NO-LOCK NO-ERROR.
               
                        ASSIGN tt-cont-emit.sequencia      = cont-emit.sequencia
                               tt-cont-emit.ind-tipo-movto = 2.  /*Modificaá∆o*/
                    END.
                END.
               
                IF  tt-cont-emit.ind-tipo-movto = 2
                AND AVAIL cont-emit THEN
                    BUFFER-COPY cont-emit EXCEPT nome TO tt-cont-emit.
               
                IF  AvailTag(c-ContactInformation,"EmailAddress") THEN
                    ASSIGN tt-cont-emit.e-mail = Getsonval(c-ContactInformation,"EmailAddress").
               
                IF  AvailTag(c-ContactInformation,"TelephoneNumber") THEN
                    ASSIGN tt-cont-emit.telefone = Getsonval(c-ContactInformation,"TelephoneNumber").
               
                IF  AvailTag(c-ContactInformation,"Fax") THEN
                    ASSIGN tt-cont-emit.telefax = Getsonval(c-ContactInformation,"Fax").
               
                IF  AvailTag(c-ContactInformation,"Ramal") THEN
                    ASSIGN tt-cont-emit.ramal = Getsonval(c-ContactInformation,"Ramal").
               
                ASSIGN i-cont = i-cont + 10.
           END.
        END.
     END.
END PROCEDURE.

PROCEDURE pi-limpa-tt:
    FOR EACH tt-emitente:
        DELETE tt-emitente.
    END.
    FOR EACH tt-dist-emitente:
        DELETE tt-dist-emitente.
    END.
    FOR EACH tt-cont-emit:
        DELETE tt-cont-emit.
    END.
    FOR EACH tt-loc-entr:
        DELETE tt-loc-entr.
    END.
    FOR EACH tt-versao-integr:
        DELETE tt-versao-integr.
    END.
    FOR EACH tt-erros-geral:
        DELETE tt-erros-geral.
    END.
    FOR EACH tt-erro-neogrid:
        DELETE tt-erro-neogrid.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE GravaClientes:
    FOR EACH tt-erros-geral:
        DELETE tt-erros-geral.
    END.

    FIND FIRST tt-emitente NO-ERROR.
    IF   tt-emitente.ind-tipo-movto = 1 THEN DO: /* Inclusao */
         RUN cdp/cd9960.p (OUTPUT i-emitente). /* Retorna o cod-emitente a ser gravado */
 	     ASSIGN tt-emitente.cod-emitente = i-emitente.
         /*S¢ inicializa os dados na inclus∆o. Nas demais situaá‰es, mantÇm o que est† na base.*/
         RUN pi-inicializa-inf-grcli IN h-api (INPUT-OUTPUT TABLE tt-emitente).
    END.
    ELSE DO:
        FIND emitente WHERE emitente.cod-emitente = i-emitente NO-LOCK NO-ERROR.

        IF  AVAIL emitente THEN DO:

            /* PCREQ-9042 - Portador do Emitente */
            assign i-portador    = emitente.portador
                   i-modalidade  = emitente.modalidade.

            if l-fn-port-emitente then do:
        
                run prgint/ufn/ufn008za.py persistent set h-api-port-fin.
                if valid-handle(h-api-port-fin) then do:
                    empty temp-table tt_log_erro.
                    run pi_busca_dados_portador_fin in h-api-port-fin (input "",
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
                    delete procedure h-api-port-fin.
                end.
            end.

            IF  tt-emitente.end-cobranca  = 0  THEN ASSIGN tt-emitente.end-cobranca  = emitente.end-cobranca.
            IF  tt-emitente.nome-matriz   = "" THEN ASSIGN tt-emitente.nome-matriz   = emitente.nome-matriz.
            IF  tt-emitente.atividade     = "" THEN ASSIGN tt-emitente.atividade     = emitente.atividade.
            IF  tt-emitente.cod-rep       = 0  THEN ASSIGN tt-emitente.cod-rep       = emitente.cod-rep.
            IF  tt-emitente.bonificacao   = 0  THEN ASSIGN tt-emitente.bonificacao   = emitente.bonificacao.
            IF  tt-emitente.portador      = 0  THEN ASSIGN tt-emitente.portador      = i-portador.
            IF  tt-emitente.modalidade    = 0  THEN ASSIGN tt-emitente.modalidade    = i-modalidade.
            IF  tt-emitente.natureza      = 0  THEN ASSIGN tt-emitente.natureza      = emitente.natureza.
            IF  tt-emitente.tp-rec-padrao = 0  THEN ASSIGN tt-emitente.tp-rec-padrao = emitente.tp-rec-padrao.
            IF  tt-emitente.nr-tabpre     = "" THEN ASSIGN tt-emitente.nr-tabpre     = emitente.nr-tabpre.
            IF  tt-emitente.moeda-libcre  = 0  THEN ASSIGN tt-emitente.moeda-libcre  = emitente.moeda-libcre.
            IF  tt-emitente.lim-credit    = 0  THEN ASSIGN tt-emitente.lim-credit    = emitente.lim-credit.
            IF  tt-emitente.dt-lim-cred   = ?  THEN ASSIGN tt-emitente.dt-lim-cred   = emitente.dt-lim-cred.
            IF  tt-emitente.esp-pd-venda  = 0  THEN ASSIGN tt-emitente.esp-pd-venda  = emitente.esp-pd-venda.
            IF  tt-emitente.tp-rec-padrao = 0  THEN ASSIGN tt-emitente.tp-rec-padrao = emitente.tp-rec-padrao.
        END.
    END.

    /* Tabela da Pauta */
    &IF DEFINED (bf_dis_adm_preco) &THEN
    &ELSE
        ASSIGN SUBSTRING(tt-emitente.char-1,1,5) = c-tab-pauta.
    &ENDIF

    FIND FIRST tt-loc-entr NO-LOCK NO-ERROR.
    IF  NOT AVAIL tt-loc-entr THEN DO:
        CREATE tt-loc-entr.
        ASSIGN tt-loc-entr.endereco     = tt-emitente.endereco
               tt-loc-entr.cidade       = tt-emitente.cidade
               tt-loc-entr.bairro       = tt-emitente.bairro
               tt-loc-entr.estado       = tt-emitente.estado
               tt-loc-entr.pais         = tt-emitente.pais
               tt-loc-entr.cep          = tt-emitente.cep
               tt-loc-entr.cod-entrega  = tt-emitente.cod-entrega
               tt-loc-entr.cgc          = tt-emitente.cgc
               tt-loc-entr.ins-estadual = tt-emitente.ins-estadual.
    END.
    RUN gravaLocalEntrega.
    RUN gravaDistEmitente.

    RUN pi-efetiva-emitente IN h-api (INPUT  TABLE tt-emitente,
                                      INPUT  TABLE tt-loc-entr,
                                      OUTPUT TABLE tt-erros-geral).

    FOR EACH tt-erros-geral :
        CREATE tt-erro-neogrid.
        ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
               tt-erro-neogrid.c-cod-estabel = c-cod-estabel
               tt-erro-neogrid.i-cod-erro    = tt-erros-geral.cod-erro
               tt-erro-neogrid.c-desc-erro   = tt-erros-geral.des-erro. 
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE GravaContatos:
    FOR EACH tt-erros-geral:
        DELETE tt-erros-geral.
    END.

    FIND FIRST tt-emitente NO-ERROR.

    for each tt-cont-emit:
        assign tt-cont-emit.cod-emitente = tt-emitente.cod-emitente.
    end.

    RUN pi-efetiva-contato IN h-api (INPUT  TABLE tt-cont-emit,
                                     OUTPUT TABLE tt-erros-geral).

    FOR EACH tt-erros-geral :
        CREATE tt-erro-neogrid.
        ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
               tt-erro-neogrid.c-cod-estabel = c-cod-estabel
               tt-erro-neogrid.i-cod-erro    = tt-erros-geral.cod-erro
               tt-erro-neogrid.c-desc-erro   = tt-erros-geral.des-erro. 
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE gravaLocalEntrega:
    FOR EACH tt-erros-geral:
        DELETE tt-erros-geral.
    END.

    FIND FIRST tt-emitente NO-ERROR.

    /* Faz relacionamento Emitente c/ Local Entrega */
    FOR EACH tt-loc-entr:
        ASSIGN tt-loc-entr.ind-tipo-movto = IF  CAN-FIND (FIRST loc-entr
                                                          WHERE loc-entr.nome-abrev  = tt-loc-entr.nome-abrev
                                                          AND   loc-entr.cod-entrega = tt-loc-entr.cod-entrega)
                                            THEN 2  /* Alteraá∆o */
                                            ELSE 1. /* Inclus∆o */
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE ReenviaXML:
    FIND FIRST tt-emitente NO-ERROR.
    FIND emitente USE-INDEX codigo WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.

    IF  AVAIL emitente
    /*AND tt-emitente.ind-tipo-movto = 1*/ THEN /* Somente na inclusao */
        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                             INPUT 2, /*CRM*/
                                             INPUT "adapters/neogrid/ftp/aneft055.p").
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE gravaDistEmitente:
    FOR EACH tt-dist-emitente:
        DELETE tt-dist-emitente.
    END.

    FIND FIRST tt-emitente NO-LOCK NO-ERROR.
    FIND dist-emitente WHERE dist-emitente.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.

    CREATE tt-dist-emitente.

    IF  AVAIL dist-emitente THEN DO:
        BUFFER-COPY dist-emitente TO tt-dist-emitente.
        ASSIGN tt-dist-emitente.ind-tipo-movto = 2 /* Modifica */
               tt-dist-emitente.nr-tb-pauta    = c-tab-pauta
               tt-dist-emitente.int-1          = i-cod-emit-externo.
    END.
    ELSE
        ASSIGN tt-dist-emitente.ind-tipo-movto = 1 /* Inclui */
               tt-dist-emitente.cod-emitente   = tt-emitente.cod-emitente
               tt-dist-emitente.nr-tb-pauta    = c-tab-pauta
               tt-dist-emitente.int-1          = i-cod-emit-externo.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE AtualizaDistEmitente:
    RUN pi-altera-dist-emitente IN h-api (INPUT  TABLE tt-dist-emitente,
                                          OUTPUT TABLE tt-erros-geral).
    FOR EACH tt-erros-geral :
        CREATE tt-erro-neogrid.
        ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
               tt-erro-neogrid.c-cod-estabel = c-cod-estabel
               tt-erro-neogrid.i-cod-erro    = tt-erros-geral.cod-erro
               tt-erro-neogrid.c-desc-erro   = tt-erros-geral.des-erro. 
    END.
    RETURN "OK":U.
END PROCEDURE.


/* Funá∆o utilizada para tratar o campo bairro para o SPED */
FUNCTION fn-valida-bairro-sped RETURNS CHAR (INPUT p-bairro AS CHAR).

     FIND FIRST pais 
          WHERE pais.cod-pais = i-pais-impto-usuario NO-LOCK NO-ERROR.
    
     IF  AVAIL pais AND pais.int-2 > 1 /* N∆o bloqueia */ THEN 
         IF  p-bairro = "" OR (
             p-bairro MATCHES "*ñ*":U  OR p-bairro MATCHES "*Ï*":U  OR 
             p-bairro MATCHES "*Å*":U  OR p-bairro MATCHES "*“*":U  OR 
             p-bairro MATCHES "*?*":U  OR p-bairro MATCHES "*^*":U  OR
             p-bairro MATCHES "*~ *":U OR p-bairro MATCHES "*ó*":U  OR
             p-bairro MATCHES "*˜*":U  OR p-bairro MATCHES "*´*":U  OR 
             p-bairro MATCHES "*ì*":U  OR p-bairro MATCHES "*ﬂ*":U  OR 
             p-bairro MATCHES "*¸*":U  OR p-bairro MATCHES "*õ*":U  OR 
             p-bairro MATCHES "*ë*":U  OR p-bairro MATCHES "*∏*":U  OR 
             p-bairro MATCHES "*‰*":U  OR p-bairro MATCHES "~~.*":U) THEN
             ASSIGN p-bairro = "N∆o Informado":U.

    RETURN p-bairro.

END FUNCTION.

&ENDIF
