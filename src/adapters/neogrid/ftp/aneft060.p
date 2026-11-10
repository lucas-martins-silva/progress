/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT060 2.00.01.013 } /*** 010113 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft060 MAN}
&ENDIF

/*------------------------------------------------------------------------

  File: ANEFT060.P

  Description: Sender de informa»„es de cr²dito para o CRM

  Input Parameters:  rw-emitente : Rowid : Rowid do emitente cujo cr²dito 
                                           deseja-se levantar informa»„es

  Output Parameters: <none>

  Author: Jean Renato Kormann / Odil B. Neto (log13165)

  Created: 04/03/2003

------------------------------------------------------------------------*/
/*           This .W file was NOT created with AppBuilder.              */
/*----------------------------------------------------------------------*/

{cdp/cdcfgdis.i}
{include/i-epc200.i}

DEF INPUT PARAM rw-emitente AS ROWID NO-UNDO.

DEF VAR i-empresa      LIKE param-global.empresa-prin         NO-UNDO.
DEF VAR i-ind-aval     LIKE emitente.ind-aval                 NO-UNDO.
DEF VAR cMsgCredito    AS CHAR                                NO-UNDO.
DEF VAR deSaldoCredito AS DEC                                 NO-UNDO.
DEF VAR de-lim-credito AS DEC FORMAT "zzz,zzz,zzz,zzz,zz9.99" NO-UNDO.
def var l-considera-replica-pd as log no-undo.  /*usado na cdapi013.i*/

DEF VAR c-root               AS CHAR NO-UNDO.
DEF VAR c-message            AS CHAR NO-UNDO.
DEF VAR c-campo              AS CHAR NO-UNDO.
DEF VAR c-FromRole           AS CHAR NO-UNDO.
DEF VAR c-ToRole             AS CHAR NO-UNDO.
DEF VAR c-CreditInformationCollection AS CHAR NO-UNDO.
DEF VAR c-CreditInformation           AS CHAR NO-UNDO.

{pdp/pd9999.i2} /* verifica»’o de cr²dito do cliente */
{cdp/cdapi013.i}  /* definic’o de TTs para cr²dito     */
{cdp/cdapi013.i1} /* verifica»’o de cr²dito do cliente */

FIND FIRST para-ped     NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.

FIND emitente WHERE ROWID(emitente) = rw-emitente NO-LOCK NO-ERROR.

IF  AVAIL emitente THEN DO:

    FIND dist-emitente WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    FIND gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.

    /*atualiza TT de emitente que ² usada para calcular o cr²dito do cliente corrente*/
    FIND FIRST tt-emitente NO-ERROR.

    IF  AVAIL tt-emitente THEN
        DELETE tt-emitente.

    CREATE tt-emitente.
    ASSIGN tt-emitente.cod-emitente = emitente.cod-emitente
           tt-emitente.nome-abrev   = emitente.nome-abrev
           tt-emitente.nr-mesina    = emitente.nr-mesina 
           i-ind-aval               = if  emitente.ind-aval = 2
                                      then 1
                                      else 3.
    RUN  pi-zera-valores.

    /* Seta empresa e estabelecimento */
    ASSIGN i-empresa = param-global.empresa-prin.
    FIND estabelec WHERE estabelec.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR.

    &IF DEFINED (bf_dis_consiste_conta) &THEN

        RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                          OUTPUT i-empresa).
    &ENDIF

    RUN pi-seta-empresa-estabel (INPUT i-empresa,
                                 INPUT para-ped.estab-padrao).
    RUN pi-determina-limite (OUTPUT de-lim-credito).
    RUN pi-verifica-pd.  /*daqui retornarÿ a variÿvel de-totvlap, que ² o total de pedidos
                           em aberto cuja situa»’o de cr²dito seja Aprovado ou Avaliado*/
    RUN pi-verifica-ft.  /*daqui retornarÿ a variÿvel de-vl-nota, que ² o total de notas n’o
                           atualizadas no CR*/
    RUN pi-saldo-cr (INPUT i-ind-aval).  /*daqui retornarÿ a variÿvel de-saldo-cr, que ² o total de
                                           t­tulos n’o baixados do cliente no CR*/
                                         /*de-tot-ad ² valor total de titulo aviso debito em atraso*/
                                         /*de-tot-tit ² valor total de titulo CR em atraso*/

    RUN pi-saldo-ap. /*daqui retornarÿ a variÿvel de-saldo-ap, que ² o total de t­tulos n’o
                       baixados para o fornecedor (no caso, ambos, cliente e fornecedor) no AP*/

    IF  param-global.modulo-mp THEN DO:
        RUN pi-verifica-mp. /*daqui retornar’o as variÿveis mp-vl-ap-abe e mp-vl-cr-abe, que s’o o
                              total de t­tulos do cliente no CR e no AP nas demais plantas do grupo
                              empresarial*/
    END.

    IF NOT l-ems5 THEN DO:
       RUN pi-verifica-mesina. /* Verificacao de Meses Inativo */
                               /* da-ult-ven, mp-dt-ult-ven - data da ultima venda no EMS
                               i-nr-meses - nr meses inativo no EMS
                               l-inativo, l-inativo-mp - log cliente inativo no EMS*/
       IF mp-dt-ult-ven > da-ult-ven THEN ASSIGN da-ult-ven = mp-dt-ult-ven.
       IF l-inativo OR l-inativo-mp THEN ASSIGN l-inativo = TRUE.

       RUN pi-verifica-atraso. /* Verificacao de atrasos no pagamento */
                               /*d-cr-ult-atraso, mp-dt-ult-atr - data ultimo atraso pagto CR EMS
                               i-qtde-cheque - nr de cheques devolvidos
                               de-tot-cheque - valor total em cheques devolvidos*/
       IF mp-dt-ult-atr > d-cr-ult-atraso THEN ASSIGN d-cr-ult-atraso = mp-dt-ult-atr.
    END.

    ASSIGN deSaldoCredito = de-lim-credito + (de-saldo-ap + mp-vl-ap-abe)
                          - (de-saldo-cr + mp-vl-cr-abe + de-vl-nota + de-totvlap).
    /*RUN adapters/neogrid/ftp/aneft060a.p (INPUT ROWID(estabelec),
                                          INPUT rowid(emitente), 
                                          INPUT (de-saldo-ap + mp-vl-ap-abe), 
                                          INPUT (de-saldo-cr + mp-vl-cr-abe), 
                                          INPUT de-vl-nota, 
                                          INPUT de-totvlap, 
                                          INPUT deSaldoCredito).
    */

    /* Montagem do XML*/
    {adapters/neogrid/include/anein004.i} /*sender*/

    /* Estabelecimento / Empresa */
    IF NOT AVAIL estabelec THEN DO:
        RETURN "NOK":U.        
    END.
    IF AVAIL estabelec THEN
        FOR FIRST empresa WHERE
           empresa.ep-codigo = estabelec.ep-codigo NO-LOCK.
        END.

    RUN pi-cabecalho-msg.
    RUN pi-corpo-msg.
    RUN pi-rodape-msg.

    WRITExml().
    /* Fim Montagem do XML*/

END.

PROCEDURE pi-zera-valores :
    ASSIGN de-saldo-ap  = 0
           de-totvlap   = 0
           de-totvlre   = 0
           de-totvlaa   = 0
           de-vl-nota   = 0
           de-saldo-cr  = 0
           de-saldo-ap  = 0
           de-saldo     = 0
           i-tot-pdap   = 0
           i-tot-pdre   = 0
           i-tot-pdaa   = 0
           i-tot-tit-cr = 0
           mp-vl-cr-abe = 0
           mp-vl-ap-abe = 0
           de-tot-tit   = 0
           de-tot-ad    = 0
           da-ult-ven   = DATE(1 ,1 ,1900)
           mp-dt-ult-ven= DATE(1 ,1 ,1900)
           l-inativo    = FALSE
           l-inativo-mp = FALSE
           i-nr-meses   = 0
           d-cr-ult-atraso = DATE(1 ,1 ,1900)
           mp-dt-ult-atr= DATE(1 ,1 ,1900)
           de-tot-cheque= 0
           i-qtde-cheque= 0. 
END PROCEDURE.

procedure pi-executa-upc.

        /************************************************** 
         EPC para determinar o nœmero mÿximo de dias em atraso 
         Usado no pi-verifica-pd , da cdapi013.i1   

         **************************************************/

        for each tt-epc
            where tt-epc.cod-event = "replicaPD":
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "replicaPD"
               tt-epc.cod-parameter = "setaReplicaPD"
               tt-epc.val-parameter = "nao".

        {include/i-epc201.i "replicaPD"}

        if can-find (first tt-epc where
                           tt-epc.cod-event     = "replicaPD" and
                           tt-epc.cod-parameter = "setaReplicaPD" and
                           tt-epc.val-parameter = "sim") then
           assign l-considera-replica-pd = yes.

end procedure.

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("CreditInformationCollections","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-CreditInformationCollection = AddElement(c-message,"CreditInformationCollection")
                 c-CreditInformation = AddElement(c-CreditInformationCollection,"CreditInformation")
               c-FromRole = AddElement(c-message,"FromRole")
               c-ToRole = AddElement(c-message,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-campo = AddEleInt(c-CreditInformation,"InternalCode", emitente.cod-emitente)
           c-campo = AddEleChar(c-CreditInformation,"ShortName", emitente.nome-abrev)
           c-campo = AddEleChar(c-CreditInformation,"LegalName", emitente.nome-emit).

    RUN pi-identificationCollection-msg.

    /* Parametros para avaliacao de credito */
    ASSIGN c-campo = AddEleChar(c-CreditInformation, "FinancialSystem", (IF l-ems5 THEN "EMS5" else "EMS2"))
           c-campo = AddEleDeci(c-CreditInformation, "CreditLimit", emitente.lim-credito)
           c-campo = AddEleDate(c-CreditInformation, "CreditLimitDate", emitente.dt-lim-cred, "")
           c-campo = AddEleDeci(c-CreditInformation, "AdditionalCreditLimit", emitente.lim-adicional)
           c-campo = AddEleDate(c-CreditInformation, "AdditionalCreditLimitDate", emitente.dt-fim-cred, "")
           c-campo = AddEleInt (c-CreditInformation, "CreditCurrency", emitente.moeda-libcre)
           c-campo = AddEleChar(c-CreditInformation, "CreditType", {adinc/i10ad098.i 04 emitente.ind-cre-cli})
           c-campo = AddEleChar(c-CreditInformation, "EvaluationType", {adinc/i09ad098.i 04 emitente.ind-aval})
           c-campo = AddEleChar(c-CreditInformation, "CreditLimitAP", (IF AVAIL(dist-emitente) AND substring(dist-emitente.char-1,1,1) = "1" THEN "True" ELSE "False"))
           c-campo = AddEleChar(c-CreditInformation, "EvaluationExtend", (IF emitente.ind-abrange-aval = 1 THEN "Cliente" ELSE "Matriz"))
           c-campo = AddEleInt (c-CreditInformation, "ReceivablePeriodOverDue", emitente.nr-peratr)
           c-campo = AddEleInt (c-CreditInformation, "ReceivableDaysOverDue", IF avail(gr-cli) THEN gr-cli.atraso-max ELSE 0)
           c-campo = AddEleInt (c-CreditInformation, "InactiveMonthMax", emitente.nr-mesina)
           c-campo = AddEleInt (c-CreditInformation, "ReturnedCheckMaxNumber", (IF emitente.nr-cheque-devol = 0 AND AVAIL(para-ped) THEN para-ped.nr-cheque-devol ELSE emitente.nr-cheque-devol))
           c-campo = AddEleDeci(c-CreditInformation, "ReturnedCheckMaxTotal", (IF emitente.vl-max-devol = 0 AND AVAIL(para-ped) THEN para-ped.vl-max-devol ELSE emitente.vl-max-devol))
           c-campo = AddEleInt (c-CreditInformation, "ReturnedCheckPeriod", (IF emitente.periodo-devol = 0 AND AVAIL(para-ped) THEN para-ped.periodo-devol ELSE emitente.periodo-devol))
           c-campo = AddEleInt (c-CreditInformation, "MaxLateCreditLockDays", IF AVAIL(para-ped) THEN para-ped.dias-maxatr ELSE 0)
           c-campo = AddEleDeci(c-CreditInformation, "MaxLateCreditLockTotal", IF AVAIL(para-ped) THEN para-ped.lim-maxatr ELSE 0)
           c-campo = AddEleInt (c-CreditInformation, "MaxLateDebitLockDays", IF AVAIL(para-ped) THEN para-ped.dias-admatr ELSE 0)
           c-campo = AddEleDeci(c-CreditInformation, "MaxLateDebitLockTotal", IF AVAIL(para-ped) THEN para-ped.lim-admatr ELSE 0)
           c-campo = AddEleInt (c-CreditInformation, "AvaliationOrderHorizon", IF AVAIL(para-ped) THEN para-ped.horiz-fixo ELSE 0).

    /* Valores para avalia»’o de credito */
    ASSIGN c-campo = AddEleDeci(c-CreditInformation, "PayableAccountsBalance", (de-saldo-ap + mp-vl-ap-abe))
           c-campo = AddEleDeci(c-CreditInformation, "ReceivableAccountsBalance", (de-saldo-cr + mp-vl-cr-abe))
           c-campo = AddEleDeci(c-CreditInformation, "InvoicesNotUpdatedAR", de-vl-nota)
           c-campo = AddEleDeci(c-CreditInformation, "ApprovedEvaluatedOrdersTotal", de-totvlap)
           c-campo = AddEleDeci(c-CreditInformation, "CurrentBalance", deSaldoCredito)
           c-campo = AddEleDeci(c-CreditInformation, "ReceivableAccountsDue", ((de-saldo-cr + mp-vl-cr-abe) - de-tot-tit))
           c-campo = AddEleDeci(c-CreditInformation, "ReceivableAccountsOverDue", de-tot-tit)
           c-campo = AddEleDeci(c-CreditInformation, "ReceivableAccountsDebitAdvice", de-tot-ad).

    /* Somente o EMS2 envia estas informa»„es, para o EMS5 ² branco*/    
    ASSIGN c-campo = AddEleDate(c-CreditInformation, "LastSellDate", da-ult-ven, "")
           c-campo = AddEleChar(c-CreditInformation, "InactiveSell", (IF l-inativo THEN "True" else "False"))
           c-campo = AddEleInt (c-CreditInformation, "InactiveMonth", i-nr-meses)
           c-campo = AddEleDate(c-CreditInformation, "ReceivableLastLateDate", d-cr-ult-atraso, "")
           c-campo = AddEleDeci(c-CreditInformation, "ReceivableReturnedCheckTotal", de-tot-cheque)
           c-campo = AddEleInt (c-CreditInformation, "ReceivableReturnedCheckNumber", i-qtde-cheque).

    
    RUN pi-ErrorCollection-msg.

END PROCEDURE.

PROCEDURE pi-identificationCollection-msg:
DEF VAR c-IdentificationCollection AS CHAR NO-UNDO.
DEF VAR c-Identification           AS CHAR NO-UNDO.

    ASSIGN c-IdentificationCollection = addElement(c-CreditInformation, "IdentificationCollection")
              c-Identification = addElement (c-IdentificationCollection, "Identification")
                 c-campo = addEleChar(c-IdentificationCollection, "IdentificationType", (IF emitente.natureza = 2 THEN "CNPJ" else "CPF"))
                 c-campo = addEleChar(c-IdentificationCollection, "IdentificationNumber", emitente.cgc).
                    
END PROCEDURE .

PROCEDURE pi-ErrorCollection-msg:
DEF VAR c-ErrorCollection AS CHAR NO-UNDO.
DEF VAR c-Error           AS CHAR NO-UNDO.

   ASSIGN c-ErrorCollection = addElement(c-CreditInformation, "ErrorCollection").
   IF l-ems5 THEN DO:
      FOR EACH tt-erros-analise-credito NO-LOCK:
         ASSIGN c-Error = addElement(c-ErrorCollection, "Error")
                c-campo = addEleInt (c-Error, "ErrorCode", tt-erros-analise-credito.cod-mensagem)
                c-campo = addEleChar(c-Error, "ErrorDescription", tt-erros-analise-credito.des-msg).
      END.
   END.
   ELSE DO:
      FOR EACH tt-erros-aval NO-LOCK:

         &IF "{&EMSFND_VERSION}" >= "1.00" &THEN
            FIND cadast_msg NO-LOCK
                WHERE cadast_msg.cdn_msg = tt-erros-aval.cd-erro no-error.
            ASSIGN c-Error = addElement(c-ErrorCollection, "Error")
                   c-campo = addEleInt (c-Error, "ErrorCode", tt-erros-aval.cd-erro)
                   c-campo = addEleChar(c-Error, "ErrorDescription", cadast_msg.des_text_msg).
         &ELSE
            FIND FIRST cad-msgs where cad-msgs.cd-msg = int(tt-erros-aval.cd-erro) no-lock no-error.
            ASSIGN c-Error = addElement(c-ErrorCollection, "Error")
                   c-campo = addEleInt (c-Error, "ErrorCode", tt-erros-aval.cd-erro)
                   c-campo = addEleChar(c-Error, "ErrorDescription", cad-msgs.texto-msg).
         &ENDIF
      END.
   END.                    
END PROCEDURE .

PROCEDURE pi-rodape-msg:
    DEF VAR c-Address AS CHAR NO-UNDO.

    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier","")
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-Address = AddElement(c-FromRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1",empresa.endereco) 
             c-campo = AddEleChar(c-Address,"AddressLine2",empresa.endereco-2) 
             c-campo = AddEleChar(c-Address,"AddressLine3","") 
             c-campo = AddEleChar(c-Address,"CityName",empresa.cidade) 
             c-campo = AddEleChar(c-Address,"DistrictName",empresa.bairro) 
             c-campo = AddEleChar(c-Address,"StateCode",empresa.uf) 
             c-campo = AddEleChar(c-Address,"LegacyCountryCode",empresa.pais) 
             c-campo = AddEleChar(c-Address,"NationalPostalCode",empresa.cep).
    
    ASSIGN c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier","")
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","")
           c-Address = AddElement(c-ToRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1","") 
             c-campo = AddEleChar(c-Address,"AddressLine2","") 
             c-campo = AddEleChar(c-Address,"AddressLine3","") 
             c-campo = AddEleChar(c-Address,"CityName","") 
             c-campo = AddEleChar(c-Address,"DistrictName","") 
             c-campo = AddEleChar(c-Address,"StateCode","") 
             c-campo = AddEleChar(c-Address,"LegacyCountryCode","") 
             c-campo = AddEleChar(c-Address,"NationalPostalCode","").
             
END PROCEDURE.

