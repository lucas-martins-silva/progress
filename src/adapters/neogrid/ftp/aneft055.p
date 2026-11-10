/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT055 2.00.00.004 } /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i aneft055 MAN}
&ENDIF

{cdp/cdcfgdis.i}
{cdp/cdcfgfin.i}
/******************************************************************************
**  Programa: aneft055.p 
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
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF BUFFER b-emitente FOR emitente.

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

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

    FUNCTION fn-trata-caracteres RETURNS CHAR (INPUT p-string AS CHAR ).
    DEFINE VARIABLE c-trata-caracteres     AS CHAR CASE-SENSITIVE NO-UNDO.
    DEFINE VARIABLE c-trata-caracteres-aux AS CHAR CASE-SENSITIVE NO-UNDO.
    DEFINE VARIABLE i-posicao              AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-codigo-asc           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-caracter             AS CHAR CASE-SENSITIVE NO-UNDO.
    
    ASSIGN c-trata-caracteres = p-string
           c-trata-caracteres = replace(c-trata-caracteres, '–', '1')
           c-trata-caracteres = replace(c-trata-caracteres, 'ì', '2')
           c-trata-caracteres = replace(c-trata-caracteres, '', '3')
           c-trata-caracteres = replace(c-trata-caracteres, 'Ò', '')
           c-trata-caracteres = replace(c-trata-caracteres, "'~'", '')
           c-trata-caracteres = replace(c-trata-caracteres, '^', '')  
           c-trata-caracteres = replace(c-trata-caracteres, 'Ê', '')
           c-trata-caracteres = replace(c-trata-caracteres, '—', '')  
           c-trata-caracteres = replace(c-trata-caracteres, ' ', 'b')
           c-trata-caracteres = replace(c-trata-caracteres, '÷', 'c')   
           c-trata-caracteres = replace(c-trata-caracteres, '«', 'c')
           c-trata-caracteres = replace(c-trata-caracteres, '“', 'c')
           c-trata-caracteres = replace(c-trata-caracteres, 'ß', 'e')
           c-trata-caracteres = replace(c-trata-caracteres, 'ü', 'f')
           c-trata-caracteres = replace(c-trata-caracteres, '›', 'o')
           c-trata-caracteres = replace(c-trata-caracteres, '‘', 'm')
           c-trata-caracteres = replace(c-trata-caracteres, '¸', 'r')
           c-trata-caracteres = replace(c-trata-caracteres, 'ä', 's')
           c-trata-caracteres = replace(c-trata-caracteres, 'Ý', 'a')
           c-trata-caracteres = replace(c-trata-caracteres, 'õ', 'o').
           
/*     IF  l-integ-tss-sincrono THEN DO:  */
        DO  i-posicao = 1 TO LENGTH(c-trata-caracteres):
            ASSIGN  c-caracter   = SUBSTR(c-trata-caracteres,i-posicao,1)
                    i-codigo-asc = ASC(c-caracter).
            
            IF  i-codigo-asc >= 32  AND
                i-codigo-asc <= 126 THEN DO:
            
                CASE i-codigo-asc:
                
                    WHEN 34 /* " */ THEN ASSIGN c-caracter = "&quot;":U.
                    WHEN 38 /* & */ THEN ASSIGN c-caracter = "&amp;":U.
                    WHEN 39 /* ' */ THEN ASSIGN c-caracter = "&#39;":U.
                    WHEN 60 /* < */ THEN ASSIGN c-caracter = "&lt;":U.
                    WHEN 62 /* > */ THEN ASSIGN c-caracter = "&gt;":U.
                
                END CASE.

                ASSIGN c-trata-caracteres-aux = c-trata-caracteres-aux + c-caracter.

            END.

        END.

        ASSIGN c-trata-caracteres = c-trata-caracteres-aux.
/*     END.                                                                   */
/*     ELSE                                                                   */
/*         ASSIGN c-trata-caracteres = replace(c-trata-caracteres, '&', 'E'). */
/*                                                                            */
    RETURN c-trata-caracteres.
END FUNCTION.
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
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-UpdatePartner = AddElement(c-message,"UpdatePartner")
                 c-PartnerCollection = AddElement(c-UpdatePartner,"PartnerCollection")
                 c-FromRole = AddElement(c-UpdatePartner,"FromRole")
                 c-ToRole = AddElement(c-UpdatePartner,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-PartnerInformation = AddElement(c-PartnerCollection,"PartnerInformation").
    RUN pi-PartnerInformation-msg.
    RUN pi-CommunicationInformation-msg.
    RUN pi-TAXInformation-msg.
    RUN pi-CreditInformation-msg.
    RUN pi-FinancialInformation-msg.
    IF  emitente.identific = 3 THEN
        RUN pi-VendorInformation-msg. 
    RUN pi-PartnerRoles-msg.
    RUN pi-IdentificationCollection-msg.
    RUN pi-AddressCollection-msg.
    RUN pi-ContactCollection-msg.
END PROCEDURE.

PROCEDURE pi-PartnerInformation-msg:
    DEF VAR c-EstablishmentInformation AS CHAR NO-UNDO.
    DEF VAR c-Individual               AS CHAR NO-UNDO.

    ASSIGN c-EstablishmentInformation = AddElement(c-PartnerInformation,"EstablishmentInformation")
           c-campo = AddEleInt(c-EstablishmentInformation,"InternalCode",emitente.cod-emitente) 
           c-campo = AddEleChar(c-EstablishmentInformation,"ShortName",emitente.nome-abrev)   
           c-campo = AddEleChar(c-EstablishmentInformation,"LegalName",emitente.nome-emit)
           c-campo = AddEleChar(c-EstablishmentInformation,"CustomerClassificationCode",IF  emitente.cod-classif-cliente > 0
                                                                                        THEN ENTRY(emitente.cod-classif-cliente,{adinc/i29ad098.i 03})
                                                                                        ELSE "")
           c-campo = AddEleDeci(c-EstablishmentInformation,"Discount",emitente.bonificacao)
           c-Individual = AddElement(c-EstablishmentInformation,"Individual")
           c-campo = AddEleChar(c-Individual,"Birthday","")   
           c-campo = AddEleChar(c-Individual,"MotherName","")   
           c-campo = AddEleChar(c-Individual,"FatherName","")   
           c-campo = AddEleChar(c-EstablishmentInformation,"Type",IF emitente.natureza > 0
                                                                  THEN ENTRY(emitente.natureza,{adinc/i03ad098.i 03})
                                                                  ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"HoldingCompany",emitente.nome-matriz)                
           c-campo = AddEleInt(c-EstablishmentInformation,"CustomerGroup",emitente.cod-gr-cli)
           c-campo = AddEleChar(c-EstablishmentInformation,"MarketActivity",emitente.atividade)
           c-campo = AddEleChar(c-EstablishmentInformation,"Category",emitente.categoria)
           c-campo = AddEleChar(c-EstablishmentInformation,"ProductLine",emitente.linha-produt)
           c-campo = AddEleInt(c-EstablishmentInformation,"RepresentativeCode",emitente.cod-rep).

    FIND repres WHERE repres.cod-rep = emitente.cod-rep NO-LOCK NO-ERROR.
    ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"Representative",IF AVAIL repres 
                                                                            THEN repres.nome-abrev
                                                                            ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"MicroTerritory",emitente.nome-mic-reg)
           c-campo = AddEleInt(c-EstablishmentInformation,"Carrier",emitente.cod-transp)
           c-campo = AddEleChar(c-EstablishmentInformation,"ReshipmentCarrier",emitente.nome-tr-red)
           c-campo = AddEleDate(c-EstablishmentInformation,"RegisterDate",emitente.data-implant,"")
           c-campo = AddEleChar(c-EstablishmentInformation,"TransactionType",emitente.nat-operacao)
           c-campo = AddEleChar(c-EstablishmentInformation,"InterstateTransactionType",emitente.nat-ope-ext)
           c-campo = AddEleInt(c-EstablishmentInformation,"StdRevenueCode",emitente.tp-rec-padrao)
           c-campo = AddElechar(c-EstablishmentInformation,"ExpenseCollectCode",IF emitente.tip-cob-desp > 0
                                                                                THEN ENTRY(emitente.tip-cob-desp,{diinc/i04di072.i 03})
                                                                                ELSE "")
           c-campo = AddEleInt(c-EstablishmentInformation,"DistributionChannelCode",emitente.cod-canal-venda)
           c-campo = AddEleChar(c-EstablishmentInformation,"PriceTable",emitente.nr-tabpre)
           c-campo = AddEleChar(c-EstablishmentInformation,"SalesOrderStdClassCode",IF  emitente.esp-pd-venda > 0
                                                                                    THEN ENTRY(emitente.esp-pd-venda,{adinc/i06ad098.i 03})
                                                                                    ELSE "") 
           c-campo = AddEleChar(c-EstablishmentInformation,"PartialInvoicing",STRING(emitente.ind-fat-par))
           c-campo = AddEleDeci(c-EstablishmentInformation,"PartialInvoicingMin",emitente.per-minfat)
           c-campo = AddEleDeci(c-EstablishmentInformation,"BalanceCancMax",emitente.per-max-canc)
           c-campo = AddEleInt(c-EstablishmentInformation,"OrderInvoicingMax",emitente.perc-fat-ped)
           c-campo = AddEleChar(c-EstablishmentInformation,"Comments",emitente.observacoes)
           c-campo = AddEleChar(c-EstablishmentInformation,"Ship-toComments",emitente.obs-entrega)
           c-campo = AddEleInt(c-EstablishmentInformation,"Bill-toAddressCode",emitente.end-cobranca).

    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    ASSIGN c-campo = AddEleDeci(c-EstablishmentInformation,"PublicityPercent",emitente.percent-verba)
           c-campo = AddEleChar(c-EstablishmentInformation,"UsePublicityGrant",STRING(emitente.utiliza-verba)).
    &else
    ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"PublicityPercent","":U)
           c-campo = AddEleChar(c-EstablishmentInformation,"UsePublicityGrant","":U).
    &endif
    ASSIGN c-campo = AddEleInt(c-EstablishmentInformation,"StdMessageCode",emitente.cod-mensagem)
           c-campo = AddEleChar(c-EstablishmentInformation,"PrintLabel",STRING(emitente.emite-etiq))
           c-campo = AddEleChar(c-EstablishmentInformation,"InventoryAllocation", IF emitente.estoque > 0
                                                                                  THEN ENTRY(emitente.estoque,{adinc/i25ad098.i 03})
                                                                                  ELSE "") 
           c-campo = AddEleInt(c-EstablishmentInformation,"EndTimeDelivery",emitente.hora-fim)
           c-campo = AddEleInt(c-EstablishmentInformation,"StartTimeDelivery",emitente.hora-ini)
           c-campo = AddEleChar(c-EstablishmentInformation,"LateIndicator", IF emitente.ind-atraso > 0
                                                                            THEN ENTRY(emitente.ind-atraso,{adinc/i18ad098.i 03})
                                                                            ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"QuantityType", IF emitente.tp-qt-prg > 0
                                                                           THEN ENTRY(emitente.tp-qt-prg,{adinc/i23ad098.i 03})
                                                                           ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"ItemXCustomer",STRING(emitente.item-cli))
           c-campo = AddEleChar(c-EstablishmentInformation,"Multi-PlantSummary", IF emitente.resumo-mp > 0 
                                                                                 THEN ENTRY(emitente.resumo-mp,{adinc/i04ad098.i 03})
                                                                                 ELSE "").

    FIND dist-emitente WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"UpdateBalanceCancelBonus",IF  AVAIL dist-emitente
                                                                                      THEN IF dist-emitente.ind-atua-bonif-canc-saldo > 0
                                                                                           THEN ENTRY(dist-emitente.ind-atua-bonif-canc-saldo,{diinc/i02di275.i 03})
                                                                                           ELSE ""
                                                                                      ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"BonusOrderGenType",IF  AVAIL dist-emitente
                                                                               THEN IF dist-emitente.ind-geracao-ped-bonif > 0
                                                                                    THEN ENTRY(dist-emitente.ind-geracao-ped-bonif,{diinc/i06di272.i 03})
                                                                                    ELSE ""
                                                                               ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"ControlsBonusOnSale",IF  AVAIL dist-emitente
                                                                                 THEN STRING(dist-emitente.log-bonif-junto-venda)
                                                                                 ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"ReleaseSaleWithoutBonus",IF  AVAIL dist-emitente
                                                                                     THEN STRING(dist-emitente.log-libera-venda-sem-bonif)
                                                                                     ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoChar1",IF  AVAIL dist-emitente
                                                                                       THEN dist-emitente.char-1
                                                                                       ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoChar2",IF  AVAIL dist-emitente
                                                                                       THEN dist-emitente.char-2
                                                                                       ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoLog1",IF  AVAIL dist-emitente
                                                                                      THEN STRING(dist-emitente.log-1)
                                                                                      ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoLog2",IF  AVAIL dist-emitente
                                                                                      THEN STRING(dist-emitente.log-2)
                                                                                      ELSE "").

    IF  AVAIL dist-emitente THEN
        ASSIGN c-campo = AddEleDeci(c-EstablishmentInformation,"EmitenteDistribuicaoDec1",dist-emitente.dec-1)
               c-campo = AddEleDeci(c-EstablishmentInformation,"EmitenteDistribuicaoDec2",dist-emitente.dec-2)
               c-campo = AddEleInt(c-EstablishmentInformation,"EmitenteDistribuicaoInt1",dist-emitente.int-1)
               c-campo = AddEleInt(c-EstablishmentInformation,"EmitenteDistribuicaoInt2",dist-emitente.int-2)
               c-campo = AddEleDate(c-EstablishmentInformation,"EmitenteDistribuicaoData1",dist-emitente.data-1,"")
               c-campo = AddEleDate(c-EstablishmentInformation,"EmitenteDistribuicaoData2",dist-emitente.data-2,"")
               c-campo = AddEleInt(c-EstablishmentInformation,"InvoicingCurr",dist-emitente.mo-fatur).
    ELSE
        ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoDec1","")
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoDec2","")
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoInt1","")
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoInt2","")
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoData1","")
               c-campo = AddEleChar(c-EstablishmentInformation,"EmitenteDistribuicaoData2","")
               c-campo = AddEleChar(c-EstablishmentInformation,"InvoicingCurr","").

    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"BonusInvafterTotal",IF  AVAIL dist-emitente
                                                                                THEN STRING(dist-emitente.log-fatur-ped-bonif)
                                                                                ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"ExternalWhs",IF  AVAIL dist-emitente
                                                                         THEN dist-emitente.cod-dep-ext
                                                                         ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"DefaultWhs",IF  AVAIL dist-emitente
                                                                        THEN dist-emitente.cod-dep-pad
                                                                        ELSE "")
           c-campo = AddEleChar(c-EstablishmentInformation,"FreightTp",IF  AVAIL dist-emitente
                                                                       THEN IF dist-emitente.ind-tp-frete > 0
                                                                            THEN ENTRY(dist-emitente.ind-tp-frete,{diinc/i01di315.i 03})
                                                                            ELSE ""
                                                                       ELSE "").
    &else
    ASSIGN c-campo = AddEleChar(c-EstablishmentInformation,"BonusInvafterTotal","":U)
           c-campo = AddEleChar(c-EstablishmentInformation,"ExternalWhs","":U)
           c-campo = AddEleChar(c-EstablishmentInformation,"DefaultWhs","":U)
           c-campo = AddEleChar(c-EstablishmentInformation,"FreightTp","":U).
    &endif
END PROCEDURE.

PROCEDURE pi-CommunicationInformation-msg:
    DEF VAR c-CommunicationInformation AS CHAR NO-UNDO.
    DEF VAR c-emit-e-mail LIKE emitente.e-mail NO-UNDO.
    ASSIGN c-emit-e-mail = fn-trata-caracteres(emitente.e-mail).

    ASSIGN c-CommunicationInformation = AddElement(c-PartnerInformation,"CommunicationInformation")
           c-campo = AddEleChar(c-CommunicationInformation,"URL",emitente.home-page)
           c-campo = AddEleChar(c-CommunicationInformation,"E-mail",c-emit-e-mail)   
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
           c-campo = AddEleChar(c-TAXInformation,"Taxpayer",STRING(emitente.contrib-icms))
           c-campo = AddEleChar(c-TAXInformation,"RetentionAgent",STRING(emitente.agente-retencao))
           c-campo = AddEleChar(c-TAXInformation,"SUFRAMACode",emitente.cod-suframa)
           c-campo = AddEleChar(c-TAXInformation,"CACEXCode",emitente.cod-cacex)
           c-campo = AddEleChar(c-TAXInformation,"AuxiliaryNumberForTributarySubst",emitente.insc-subs-trib).

    &if DEFINED (bf_dis_adm_preco) &then
        FIND dist-emitente WHERE dist-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN c-campo = AddEleChar(c-TAXInformation,"TabeladePauta",IF  AVAIL dist-emitente
                                                                     THEN dist-emitente.nr-tb-pauta
                                                                     ELSE "").
    &else
        ASSIGN c-campo = AddEleChar(c-TAXInformation,"TabeladePauta",SUBSTR(emitente.char-1,1,5)).
    &endif

    ASSIGN c-campo = AddEleInt(c-TAXInformation,"TaxExemptionCode",emitente.cod-isencao)
           c-campo = AddEleInt(c-TAXInformation,"TaxCode",emitente.cod-tax)
           c-campo = AddEleChar(c-TAXInformation,"SalesTaxPerception",STRING(emitente.percepcao)).
END PROCEDURE.

PROCEDURE pi-CreditInformation-msg:
    DEF VAR c-CreditInformation AS CHAR NO-UNDO.

    ASSIGN c-CreditInformation = AddElement(c-PartnerInformation,"CreditInformation")
           c-campo = AddEleChar(c-CreditInformation,"CreditIndicator", IF emitente.ind-cre-cli > 0
                                                                       THEN ENTRY(emitente.ind-cre-cli,{adinc/i10ad098.i 03})
                                                                       ELSE "")
           c-campo = AddEleInt(c-CreditInformation,"CreditLimitCurrency",emitente.moeda-libcre)
           c-campo = AddEleChar(c-CreditInformation,"CreditEvaluation", IF emitente.ind-aval > 0
                                                                        THEN ENTRY(emitente.ind-aval,{adinc/i09ad098.i 03})
                                                                        ELSE "")
           c-campo = AddEleChar(c-CreditInformation,"ShipmentCreditEvaluation", IF emitente.ind-aval-embarque > 0
                                                                                THEN ENTRY(emitente.ind-aval-embarque,{adinc/i09ad098.i 03})
                                                                                ELSE "")
           c-campo = AddEleChar(c-CreditInformation,"EvaluationScope", IF emitente.ind-abrange-aval > 0
                                                                       THEN ENTRY(emitente.ind-abrange-aval,{adinc/i24ad098.i 03})
                                                                       ELSE "")
           c-campo = AddEleChar(c-CreditInformation,"ReleaseInventoryWithoutReleaseCredit",STRING(emitente.ind-lib-estoque))
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
           c-campo = AddEleChar(c-FinancialInformation,"CollectorMode",IF  i-modalidade > 0 THEN
                                                                       ENTRY(i-modalidade,{adinc/i03ad209.i 03})
                                                                       ELSE "") 
           c-campo = AddEleChar(c-FinancialInformation,"PreferencialCollectorMode", IF i-mod-prefer > 0
                                                                                    THEN ENTRY(i-mod-prefer,{adinc/i03ad209.i 03})
                                                                                    ELSE "") 
           c-campo = AddEleChar(c-FinancialInformation,"PenaltyCalc",STRING(emitente.calcula-multa))
           c-campo = AddEleDate(c-FinancialInformation,"FinancialRateDate",emitente.data-taxa,"")
           c-campo = AddEleChar(c-FinancialInformation,"Statement",STRING(emitente.emite-bloq))
           c-campo = AddEleChar(c-FinancialInformation,"GenerateDebitMemo",STRING(emitente.gera-ad))
           c-campo = AddEleInt(c-FinancialInformation,"GeneratePriceDifference",emitente.gera-difer)
           c-campo = AddEleInt(c-FinancialInformation,"NumberOfDays",emitente.nr-dias)
           c-campo = AddEleInt(c-FinancialInformation,"NoOfDaysOverdue",emitente.nr-dias-atraso)
           c-campo = AddEleChar(c-FinancialInformation,"ReceiveInformationSCI",STRING(emitente.recebe-inf-sci))
           c-campo = AddEleDeci(c-FinancialInformation,"MinAmountForDebitMemoGen",emitente.vl-min-ad)
           c-campo = AddEleInt(c-FinancialInformation,"PaymentTerm",emitente.cod-cond-pag)
           c-campo = AddEleDeci(c-FinancialInformation,"MinimumAmount",emitente.valor-minimo).
END PROCEDURE.

PROCEDURE pi-VendorInformation-msg:
    DEF VAR c-VendorInformation AS CHAR NO-UNDO.

    ASSIGN c-VendorInformation = AddElement(c-PartnerInformation,"VendorInformation")
           c-campo = AddEleInt(c-VendorInformation,"VendorGroupCode",emitente.cod-gr-forn)
           c-campo = AddEleChar(c-VendorInformation,"VendorClassificationLevelCode",IF  emitente.cod-classif-fornec > 0
                                                                                    THEN ENTRY(emitente.cod-classif-fornec,{adinc/i29ad098.i 03})
                                                                                    ELSE "")                                
           c-campo = AddEleChar(c-VendorInformation,"PaymentStatus",IF  emitente.flag-pag > 0
                                                                    THEN ENTRY(emitente.flag-pag,{adinc/i26ad098.i 03})
                                                                    ELSE "")
           c-campo = AddEleChar(c-VendorInformation,"ExportationServices",STRING(emitente.forn-exp))
           c-campo = AddEleChar(c-VendorInformation,"Licensor",STRING(emitente.ind-licenciador))
           c-campo = AddEleDeci(c-VendorInformation,"PeriodPurchase",emitente.compr-period)
           c-campo = AddEleInt(c-VendorInformation,"NumberOfCopies",emitente.nr-copias-ped)
           c-campo = AddEleInt(c-VendorInformation,"StdRevenueCode",emitente.tp-desp-padrao)
           c-campo = AddEleChar(c-VendorInformation,"DueSaturday",IF  emitente.ven-sabado > 0
                                                                  THEN ENTRY(emitente.ven-sabado,{adinc/i17ad098.i 03})
                                                                  ELSE "")
           c-campo = AddEleChar(c-VendorInformation,"DueSunday",IF  emitente.ven-domingo > 0
                                                                THEN ENTRY(emitente.ven-domingo,{adinc/i17ad098.i 03})
                                                                ELSE "")
           c-campo = AddEleChar(c-VendorInformation,"DueHoliday",IF  emitente.ven-feriado > 0
                                                                 THEN ENTRY(emitente.ven-feriado,{adinc/i17ad098.i 03})
                                                                 ELSE "")
           c-campo = AddEleDeci(c-VendorInformation,"FinancialRate",emitente.taxa-financ)
           c-campo = AddEleInt(c-VendorInformation,"FinancialRateDays",emitente.nr-dias-taxa)
           c-campo = AddEleInt(c-VendorInformation,"ImportationRepresentative",emitente.cod-repres-imp)
           c-campo = AddEleChar(c-VendorInformation,"RetentionAuthority", IF emitente.ind-emit-retencao > 0
                                                                          THEN ENTRY(emitente.ind-emit-retencao,{adinc/i28ad098.i 03})
                                                                          ELSE "")
           c-campo = AddEleInt(c-VendorInformation,"NoDocuments",emitente.nr-titulo)
           c-campo = AddEleChar(c-VendorInformation,"Revenue",STRING(emitente.ind-rendiment))
           c-campo = AddEleInt(c-VendorInformation,"ClearanceDays",emitente.dias-comp)
           c-campo = AddEleChar(c-VendorInformation,"DueEqualFlowDate",STRING(emitente.vencto-dia-nao-util))
           c-campo = AddEleDeci(c-VendorInformation,"TaxableRevenue",emitente.rend-tribut)
           c-campo = AddEleInt(c-VendorInformation,"TaxProgressiveTableCode",emitente.nr-tab-progr)
           c-campo = AddEleChar(c-VendorInformation,"PaymentType", IF emitente.tp-pagto > 0
                                                                   THEN ENTRY(emitente.tp-pagto,{adinc/i22ad098.i 03})
                                                                   ELSE "").
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

    ASSIGN c-IdentificationCollection = AddElement(c-PartnerInformation,"IdentificationCollection")
           c-Identification = AddElement(c-IdentificationCollection,"Identification")
           c-campo = AddEleChar(c-Identification,"IdentificationType",IF emitente.natureza = 1
                                                                      THEN "CPF"
                                                                      ELSE "CNPJ")
           c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc).

    IF  emitente.ins-estadual <> "" THEN
        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")     
               c-campo = AddEleChar(c-Identification,"IdentificationType","IE") 
               c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-estadual).

    IF  emitente.ins-municipal <> "" THEN
    ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")     
           c-campo = AddEleChar(c-Identification,"IdentificationType","IM") 
           c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-municipal).
END PROCEDURE.

PROCEDURE pi-AddressCollection-msg:
    DEF VAR c-AddressCollection        AS CHAR NO-UNDO.
    DEF VAR c-IdentificationCollection AS CHAR NO-UNDO.
    DEF VAR c-Identification           AS CHAR NO-UNDO.
    DEF VAR c-Address                  AS CHAR NO-UNDO.

    ASSIGN c-AddressCollection          = AddElement(c-PartnerInformation,"AddressCollection").
             /* Tipo 2 - End Entrega */
    FOR EACH  loc-entr NO-LOCK
        WHERE loc-entr.nome-abrev = emitente.nome-abrev :

        ASSIGN c-Address = AddElement(c-AddressCollection,"Address")
               c-campo = AddEleInt(c-Address,"AddressType",2) 
               c-campo = AddEleChar(c-Address,"AddressLine1",loc-entr.endereco) 
               c-campo = AddEleChar(c-Address,"AddressLine2","") 
               c-campo = AddEleChar(c-Address,"AddressLine3","") 
               c-campo = AddEleChar(c-Address,"CityName",loc-entr.cidade) 
               c-campo = AddEleChar(c-Address,"DistrictName",loc-entr.bairro) 
               c-campo = AddEleChar(c-Address,"StateCode",loc-entr.estado) 
               c-campo = AddEleChar(c-Address,"LegacyCountryCode",loc-entr.pais) 
               c-campo = AddEleChar(c-Address,"NationalPostalCode",loc-entr.cep) 
               c-campo = AddEleChar(c-Address,"RegionName","") 
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
    END.
             /* Tipo 3 - End Cobran‡a */

    ASSIGN c-Address = AddElement(c-AddressCollection,"Address")
           c-campo = AddEleInt(c-Address,"AddressType",3).

    IF  emitente.endereco-cob <> ""
    OR  emitente.end-cobranca <> 0 THEN DO:
        IF  emitente.endereco-cob <> "" THEN DO:
            ASSIGN c-campo = AddEleChar(c-Address,"AddressLine1",emitente.endereco-cob)
                   c-campo = AddEleChar(c-Address,"AddressLine2","")
                   c-campo = AddEleChar(c-Address,"AddressLine3","")
                   c-campo = AddEleChar(c-Address,"CityName",emitente.cidade-cob)
                   c-campo = AddEleChar(c-Address,"DistrictName",emitente.bairro-cob)
                   c-campo = AddEleChar(c-Address,"StateCode",emitente.estado-cob)
                   c-campo = AddEleChar(c-Address,"LegacyCountryCode",emitente.pais-cob)
                   c-campo = AddEleChar(c-Address,"NationalPostalCode",emitente.cep-cob)
                   c-campo = AddEleChar(c-Address,"RegionName","")
                   c-campo = AddEleChar(c-Address,"AddressCode","")
                   c-campo = AddEleChar(c-Address,"POBox",emitente.cx-post-cob)
                   c-campo = AddEleChar(c-Address,"ZipCode",emitente.zip-cob-code)
                   c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
                   c-Identification = AddElement(c-IdentificationCollection,"Identification")
                   c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                              THEN "CPF"
                                                                              ELSE "CNPJ")
                   c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc-cob).

            IF  emitente.ins-est-cob <> "" THEN
            ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                   c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                   c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-est-cob).
        END.
        ELSE DO:
            IF  emitente.end-cobranca = emitente.cod-emitente THEN DO:
                ASSIGN c-campo = AddEleChar(c-Address,"AddressLine1",emitente.endereco)
                   c-campo = AddEleChar(c-Address,"AddressLine2","")
                   c-campo = AddEleChar(c-Address,"AddressLine3","")
                   c-campo = AddEleChar(c-Address,"CityName",emitente.cidade)
                   c-campo = AddEleChar(c-Address,"DistrictName",emitente.bairro)
                   c-campo = AddEleChar(c-Address,"StateCode",emitente.estado)
                   c-campo = AddEleChar(c-Address,"LegacyCountryCode",emitente.pais)
                   c-campo = AddEleChar(c-Address,"NationalPostalCode",emitente.cep)
                   c-campo = AddEleChar(c-Address,"RegionName","")
                   c-campo = AddEleChar(c-Address,"AddressCode","")
                   c-campo = AddEleChar(c-Address,"POBox",emitente.caixa-postal)
                   c-campo = AddEleChar(c-Address,"ZipCode",emitente.zip-code)
                   c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
                   c-Identification = AddElement(c-IdentificationCollection,"Identification")
                   c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                              THEN "CPF"
                                                                              ELSE "CNPJ")
                   c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc).

                IF  emitente.ins-estadual <> "" THEN
                    ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                           c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                           c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-estadual).

                IF  emitente.ins-municipal <> "" THEN
                    ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                           c-campo = AddEleChar(c-Identification,"IdentificationType","IM")
                           c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-municipal).
            END.
            ELSE DO:
                FIND b-emitente WHERE b-emitente.cod-emitente = emitente.end-cobranca NO-LOCK NO-ERROR.
                IF  AVAIL b-emitente THEN DO:
                    IF  b-emitente.endereco-cob <> "" THEN DO:
                        ASSIGN c-campo = AddEleChar(c-Address,"AddressLine1",b-emitente.endereco-cob)
                               c-campo = AddEleChar(c-Address,"AddressLine2","")
                               c-campo = AddEleChar(c-Address,"AddressLine3","")
                               c-campo = AddEleChar(c-Address,"CityName",b-emitente.cidade-cob)
                               c-campo = AddEleChar(c-Address,"DistrictName",b-emitente.bairro-cob)
                               c-campo = AddEleChar(c-Address,"StateCode",b-emitente.estado-cob)
                               c-campo = AddEleChar(c-Address,"LegacyCountryCode",b-emitente.pais-cob)
                               c-campo = AddEleChar(c-Address,"NationalPostalCode",b-emitente.cep-cob)
                               c-campo = AddEleChar(c-Address,"RegionName","")
                               c-campo = AddEleChar(c-Address,"AddressCode","")
                               c-campo = AddEleChar(c-Address,"POBox",b-emitente.cx-post-cob)
                               c-campo = AddEleChar(c-Address,"ZipCode",b-emitente.zip-cob-code)
                               c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
                               c-Identification = AddElement(c-IdentificationCollection,"Identification")
                               c-campo = AddEleChar(c-Identification,"IdentificationType",IF  b-emitente.natureza = 1
                                                                                          THEN "CPF"
                                                                                          ELSE "CNPJ")
                               c-campo = AddEleChar(c-Identification,"IdentificationNumber",b-emitente.cgc-cob).

                        IF  b-emitente.ins-est-cob <> "" THEN
                            ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                                   c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                                   c-campo = AddEleChar(c-Identification,"IdentificationNumber",b-emitente.ins-est-cob).
                    END.
                    ELSE DO:
                        IF  b-emitente.end-cobranca = b-emitente.cod-emitente THEN DO:
                            ASSIGN c-campo = AddEleChar(c-Address,"AddressLine1",b-emitente.endereco)
                                   c-campo = AddEleChar(c-Address,"AddressLine2","")
                                   c-campo = AddEleChar(c-Address,"AddressLine3","")
                                   c-campo = AddEleChar(c-Address,"CityName",b-emitente.cidade)
                                   c-campo = AddEleChar(c-Address,"DistrictName",b-emitente.bairro)
                                   c-campo = AddEleChar(c-Address,"StateCode",b-emitente.estado)
                                   c-campo = AddEleChar(c-Address,"LegacyCountryCode",b-emitente.pais)
                                   c-campo = AddEleChar(c-Address,"NationalPostalCode",b-emitente.cep)
                                   c-campo = AddEleChar(c-Address,"RegionName","")
                                   c-campo = AddEleChar(c-Address,"AddressCode","")
                                   c-campo = AddEleChar(c-Address,"POBox",b-emitente.caixa-postal)
                                   c-campo = AddEleChar(c-Address,"ZipCode",b-emitente.zip-code)
                                   c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
                                   c-Identification = AddElement(c-IdentificationCollection,"Identification")
                                   c-campo = AddEleChar(c-Identification,"IdentificationType",IF  b-emitente.natureza = 1
                                                                                              THEN "CPF"
                                                                                              ELSE "CNPJ")
                                   c-campo = AddEleChar(c-Identification,"IdentificationNumber",b-emitente.cgc).

                            IF  b-emitente.ins-estadual <> "" THEN
                                ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                                       c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                                       c-campo = AddEleChar(c-Identification,"IdentificationNumber",b-emitente.ins-estadual).

                            IF  b-emitente.ins-municipal <> "" THEN
                                ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                                       c-campo = AddEleChar(c-Identification,"IdentificationType","IM")
                                       c-campo = AddEleChar(c-Identification,"IdentificationNumber",b-emitente.ins-municipal).
                        END.
                    END.
                END.
                ELSE DO:
                    ASSIGN c-campo = AddEleChar(c-Address,"AddressLine1",emitente.endereco)
                           c-campo = AddEleChar(c-Address,"AddressLine2","")
                           c-campo = AddEleChar(c-Address,"AddressLine3","")
                           c-campo = AddEleChar(c-Address,"CityName",emitente.cidade)
                           c-campo = AddEleChar(c-Address,"DistrictName",emitente.bairro)
                           c-campo = AddEleChar(c-Address,"StateCode",emitente.estado)
                           c-campo = AddEleChar(c-Address,"LegacyCountryCode",emitente.pais)
                           c-campo = AddEleChar(c-Address,"NationalPostalCode",emitente.cep)
                           c-campo = AddEleChar(c-Address,"RegionName","")
                           c-campo = AddEleChar(c-Address,"AddressCode","")
                           c-campo = AddEleChar(c-Address,"POBox",emitente.caixa-postal)
                           c-campo = AddEleChar(c-Address,"ZipCode",emitente.zip-code)
                           c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
                           c-Identification = AddElement(c-IdentificationCollection,"Identification")
                           c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                                      THEN "CPF"
                                                                                      ELSE "CNPJ")
                           c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc).

                    IF  emitente.ins-estadual <> "" THEN
                        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                               c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                               c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-estadual).

                    IF  emitente.ins-municipal <> "" THEN
                        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                               c-campo = AddEleChar(c-Identification,"IdentificationType","IM")
                               c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-municipal).
                END.
            END.
        END.
    END.
    ELSE DO:
        ASSIGN c-campo = AddEleChar(c-Address,"AddressLine1",emitente.endereco)
               c-campo = AddEleChar(c-Address,"AddressLine2","")
               c-campo = AddEleChar(c-Address,"AddressLine3","")
               c-campo = AddEleChar(c-Address,"CityName",emitente.cidade)
               c-campo = AddEleChar(c-Address,"DistrictName",emitente.bairro)
               c-campo = AddEleChar(c-Address,"StateCode",emitente.estado)
               c-campo = AddEleChar(c-Address,"LegacyCountryCode",emitente.pais)
               c-campo = AddEleChar(c-Address,"NationalPostalCode",emitente.cep)
               c-campo = AddEleChar(c-Address,"RegionName","")
               c-campo = AddEleChar(c-Address,"AddressCode","")
               c-campo = AddEleChar(c-Address,"POBox",emitente.caixa-postal)
               c-campo = AddEleChar(c-Address,"ZipCode",emitente.zip-code)
               c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
               c-Identification = AddElement(c-IdentificationCollection,"Identification")
               c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                          THEN "CPF"
                                                                          ELSE "CNPJ")
               c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc).

        IF  emitente.ins-estadual <> "" THEN
            ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                   c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
                   c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-estadual).

        IF  emitente.ins-municipal <> "" THEN
            ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
                   c-campo = AddEleChar(c-Identification,"IdentificationType","IM")
                   c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-municipal).
    END.

    /* Tipo 8 - Endereco Principal */
    ASSIGN c-Address = AddElement(c-AddressCollection,"Address")
           c-campo = AddEleInt(c-Address,"AddressType",8)
           c-campo = AddEleChar(c-Address,"AddressLine1",emitente.endereco)
           c-campo = AddEleChar(c-Address,"AddressLine2",emitente.endereco2)
           c-campo = AddEleChar(c-Address,"AddressLine3","")
           c-campo = AddEleChar(c-Address,"CityName",emitente.cidade)
           c-campo = AddEleChar(c-Address,"DistrictName",emitente.bairro)
           c-campo = AddEleChar(c-Address,"StateCode",emitente.estado)
           c-campo = AddEleChar(c-Address,"LegacyCountryCode",emitente.pais)
           c-campo = AddEleChar(c-Address,"NationalPostalCode",emitente.cep)
           c-campo = AddEleChar(c-Address,"RegionName","")
           c-campo = AddEleChar(c-Address,"AddressCode",emitente.cod-entrega)
           c-campo = AddEleChar(c-Address,"POBox",emitente.caixa-postal)
           c-campo = AddEleChar(c-Address,"ZipCode",emitente.zip-code)
           c-campo = AddEleChar(c-Address,"County",emitente.cn-codigo)
           c-IdentificationCollection = AddElement(c-Address,"IdentificationCollection")
           c-Identification = AddElement(c-IdentificationCollection,"Identification")
           c-campo = AddEleChar(c-Identification,"IdentificationType",IF  emitente.natureza = 1
                                                                      THEN "CPF"
                                                                      ELSE "CNPJ")
           c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.cgc).

    IF  emitente.ins-estadual <> "" THEN
        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
               c-campo = AddEleChar(c-Identification,"IdentificationType","IE")
               c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-estadual).

    IF  emitente.ins-municipal <> "" THEN
        ASSIGN c-Identification = AddElement(c-IdentificationCollection,"Identification")
               c-campo = AddEleChar(c-Identification,"IdentificationType","IM")
               c-campo = AddEleChar(c-Identification,"IdentificationNumber",emitente.ins-municipal).
END PROCEDURE.

PROCEDURE pi-ContactCollection-msg:
    DEF VAR c-ContactCollection  AS CHAR NO-UNDO.
    DEF VAR c-ContactInformation AS CHAR NO-UNDO.
    DEF VAR c-ContactName        LIKE cont-emit.nome   NO-UNDO.
    DEF VAR c-contemit-e-mail    LIKE cont-emit.e-mail NO-UNDO.

    ASSIGN c-ContactCollection = AddElement(c-PartnerInformation,"ContactCollection").
    FOR EACH  cont-emit NO-LOCK
        WHERE cont-emit.cod-emitente = emitente.cod-emitente:
        ASSIGN c-ContactName     = fn-trata-caracteres(cont-emit.nome).
        ASSIGN c-contemit-e-mail = fn-trata-caracteres(cont-emit.e-mail).
        ASSIGN c-ContactInformation = AddElement(c-ContactCollection,"ContactInformation")
               c-campo = AddEleInt(c-ContactInformation,"Sequence",cont-emit.sequencia)
               c-campo = AddEleChar(c-ContactInformation,"ContactName",c-ContactName) 
               c-campo = AddEleChar(c-ContactInformation,"TelephoneNumber",cont-emit.telefone)
               c-campo = AddEleChar(c-ContactInformation,"EmailAddress",c-contemit-e-mail) 
               c-campo = AddEleChar(c-ContactInformation,"Fax",cont-emit.telefax) 
               c-campo = AddEleChar(c-ContactInformation,"Ramal",cont-emit.ramal)
               c-campo = AddEleChar(c-ContactInformation,"Area",cont-emit.area)
               c-campo = AddEleChar(c-ContactInformation,"Cargo",cont-emit.cargo). 
    END.
END PROCEDURE.

PROCEDURE pi-rodape-msg:
    DEF VAR c-Address            AS CHAR NO-UNDO.
    DEF VAR c-ContactInformation AS CHAR NO-UNDO.

    FIND FIRST estabelec WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
    IF  AVAIL estabelec THEN
        FIND FIRST empresa WHERE empresa.ep-codigo = estabelec.ep-codigo NO-LOCK NO-ERROR.

    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier","")
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-ContactInformation = AddElement(c-FromRole,"ContactInformation")
           c-campo = AddEleChar(c-ContactInformation,"ContactName","")
           c-campo = AddEleChar(c-ContactInformation,"TelephoneNumber","")
           c-campo = AddEleChar(c-ContactInformation,"EmailAddress","")
           c-Address = AddElement(c-FromRole,"Address")
           c-campo = AddEleChar(c-Address,"AddressLine1",IF  AVAIL empresa
                                                         THEN empresa.endereco
                                                         ELSE "") 
           c-campo = AddEleChar(c-Address,"AddressLine2",IF  AVAIL empresa
                                                         THEN empresa.endereco-2
                                                         ELSE "") 
           c-campo = AddEleChar(c-Address,"AddressLine3","") 
           c-campo = AddEleChar(c-Address,"CityName",IF  AVAIL empresa
                                                     THEN empresa.cidade
                                                     ELSE "")
           c-campo = AddEleChar(c-Address,"DistrictName",IF  AVAIL empresa
                                                         THEN empresa.bairro
                                                         ELSE "")
           c-campo = AddEleChar(c-Address,"StateCode",IF  AVAIL empresa
                                                      THEN empresa.uf
                                                      ELSE "")
           c-campo = AddEleChar(c-Address,"LegacyCountryCode",IF  AVAIL empresa
                                                              THEN empresa.pais
                                                              ELSE "")
           c-campo = AddEleChar(c-Address,"NationalPostalCode",IF  AVAIL empresa
                                                               THEN empresa.cep
                                                               ELSE "")
           c-campo = AddEleChar(c-Address,"RegionName","") 
           c-campo = AddEleChar(c-Address,"AddressCode","")
           c-campo = AddEleChar(c-Address,"EmailAddress",""). 

    ASSIGN c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier","")
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

&ENDIF
