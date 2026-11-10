/************************ axrvd003Query.i - PIQuery ***************************/
/*** Retorna registros conforme parƒmetros enviados na mensagem de consulta ***/

/* Variaveis utilizadas na leitura da mensagem de consulta */
DEF VAR i-nr-pedido-ini   AS INT   NO-UNDO.
DEF VAR i-nr-pedido-fim   AS INT   NO-UNDO INITIAL ?.
DEF VAR c-nr-ped-crm-ini  AS CHAR  NO-UNDO.
DEF VAR c-nr-ped-crm-fim  AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-nome-abrev-ini  AS CHAR  NO-UNDO.
DEF VAR c-nome-abrev-fim  AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-nr-pedcli-ini   AS CHAR  NO-UNDO.
DEF VAR c-nr-pedcli-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-cod-estab-ini   AS CHAR  NO-UNDO.
DEF VAR c-cod-estab-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-no-ab-rep-ini   AS CHAR  NO-UNDO.
DEF VAR c-no-ab-rep-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR i-cod-priori-ini  AS INT   NO-UNDO.
DEF VAR i-cod-priori-fim  AS INT   NO-UNDO INITIAL ?.
DEF VAR c-tp-pedido-ini   AS CHAR  NO-UNDO.
DEF VAR c-tp-pedido-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR i-canal-venda-ini AS INT   NO-UNDO.
DEF VAR i-canal-venda-fim AS INT   NO-UNDO INITIAL ?.
DEF VAR d-dt-emissao-ini  AS DATE  NO-UNDO INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
DEF VAR d-dt-emissao-fim  AS DATE  NO-UNDO INITIAL ?.
DEF VAR d-dt-implant-ini  AS DATE  NO-UNDO INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
DEF VAR d-dt-implant-fim  AS DATE  NO-UNDO INITIAL ?.
DEF VAR d-dt-entrega-ini  AS DATE  NO-UNDO INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
DEF VAR d-dt-entrega-fim  AS DATE  NO-UNDO INITIAL ?.
DEF VAR d-dt-cancela-ini  AS DATE  NO-UNDO INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
DEF VAR d-dt-cancela-fim  AS DATE  NO-UNDO INITIAL ?.
DEF VAR i-esp-ped         AS INT   NO-UNDO INITIAL 1.  
DEF VAR l-aberto          AS LOG   NO-UNDO INITIAL TRUE. 
DEF VAR l-atendido-parc   AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-atendido-tot    AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-pendente        AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-suspenso        AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-cancelado       AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-avaliado        AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-nao-avaliado    AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-aprovado        AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-nao-aprovado    AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-pendeinfo       AS LOG   NO-UNDO INITIAL TRUE.

/* Variaveis utilizadas na constru‡Æo da mensagem de retorno */
DEF NEW GLOBAL SHARED VAR iFirstId           AS INT NO-UNDO.   
/* Vendor */
DEF NEW GLOBAL SHARED VAR iListPaymentCodes  AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iVendorInfo        AS INT NO-UNDO.
/* Comex */
DEF NEW GLOBAL SHARED VAR iArrival           AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iConsignee         AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iControlPoint      AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iCurrency          AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iDeclaration       AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iDispatch          AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iExpense           AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iExpensePriceTable AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iExpenseType       AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iExpenseVendor     AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iExportInfo        AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iItinerary         AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iMark              AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iLanding           AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iListExpenses      AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iListMarks         AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iNotifying         AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iOrderExport       AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iPaymentPlan       AS INT NO-UNDO.
DEF NEW GLOBAL SHARED VAR iShipment          AS INT NO-UNDO.

DEF VAR iRoot             AS INT   NO-UNDO.   
DEF VAR iAddition         AS INT   NO-UNDO.
DEF VAR iAdditionUser     AS INT   NO-UNDO.
DEF VAR iCancellationUser AS INT   NO-UNDO.
DEF VAR iCustomer         AS INT   NO-UNDO.
DEF VAR iCurrency         AS INT   NO-UNDO.
DEF VAR iDeliveryLocation AS INT   NO-UNDO.
DEF VAR iDeliveryAddress  AS INT   NO-UNDO.
DEF VAR iDiscount         AS INT   NO-UNDO.
DEF VAR iFiscalOperation  AS INT   NO-UNDO.
DEF VAR iLastUpdUser      AS INT   NO-UNDO.
DEF VAR iListDiscounts    AS INT   NO-UNDO.
DEF VAR iPrice            AS INT   NO-UNDO.
DEF VAR iPriceAppUser     AS INT   NO-UNDO.
DEF VAR iReactivationUser AS INT   NO-UNDO.
DEF VAR iSalesTax         AS INT   NO-UNDO.
DEF VAR iSuspensionUser   AS INT   NO-UNDO.
DEF VAR iTaxes            AS INT   NO-UNDO.
DEF VAR l-cancel          AS LOG   NO-UNDO INITIAL NO.
DEF VAR l-devol           AS LOG   NO-UNDO INITIAL NO.
DEF VAR l-last-upd        AS LOG   NO-UNDO INITIAL NO.
DEF VAR l-reativ          AS LOG   NO-UNDO INITIAL NO.
DEF VAR l-susp            AS LOG   NO-UNDO INITIAL NO.
DEF VAR l-val-desc        AS LOG   NO-UNDO INITIAL NO.
DEF VAR c-msg-dsp-pre     AS CHAR  NO-UNDO INITIAL NO.
DEF VAR i-seq-parcela     AS INT   NO-UNDO.
DEF VAR c-sit-item        AS CHAR  NO-UNDO FORMAT "x(11)":U INIT "1,2,3,4,5,6":U.
DEF VAR i-cont            AS INT   NO-UNDO.
DEF VAR i-cont-err        AS INT   NO-UNDO.
DEF VAR pErrorNumber      AS INT   NO-UNDO.
DEF VAR pErrorType        AS CHAR  NO-UNDO.
DEF VAR pErrorDesc        AS CHAR  NO-UNDO.

DEF TEMP-TABLE tt-ped-venda-qry NO-UNDO 
         FIELD nr-pedcli  LIKE ped-venda.nr-pedcli
         FIELD nome-abrev LIKE ped-venda.nome-abrev
    .

{adapters/xml/vd2/axsvd003.i}

PROCEDURE piQuery: 

    /* retorna handle da mensagem que cont‚m os registros encontrados */
    DEF OUTPUT PARAM  hQueryReturnContent AS HANDLE NO-UNDO.

    RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).
    RUN reset              IN hGenXml.
    RUN loadXml            IN hGenXml (hBusinessContent).

    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Lˆ mensagem enviada que cont‚m as faixas/parƒmetros de sele‡Æo da consulta */
    RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId). /* Query */
    addStack(iId). 

          EMPTY TEMP-TABLE tt-ped-venda-qry NO-ERROR.

          /* ListOfCustomerOrderNumbers ->> pedidos informados na mensagem de consulta */
          RUN searchTag IN hGenXml (INPUT "ListOfCustomerOrderNumbers":U, INPUT getStack(), OUTPUT iId).
          IF iId <> ? THEN DO:
              addStack(iId).

              /* Order */
              RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).
              DO WHILE iId <> ?:
                 addStack(iId).
                 RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "CustomerOrderNumber":U, OUTPUT c-nr-pedcli-ini).
                 RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "CustomerShortName":U,   OUTPUT c-nome-abrev-ini).

                 IF NOT CAN-FIND(FIRST tt-ped-venda-qry WHERE tt-ped-venda-qry.nr-pedcli  = c-nr-pedcli-ini   AND
                                                              tt-ped-venda-qry.nome-abrev = c-nome-abrev-ini) THEN DO:
                           CREATE tt-ped-venda-qry.
                           ASSIGN tt-ped-venda-qry.nr-pedcli  = c-nr-pedcli-ini   
                                  tt-ped-venda-qry.nome-abrev = c-nome-abrev-ini.
                 END.

                 ASSIGN iId = getStack().
                 delStack().
                 RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId).
              END.
              delStack().
          END.

          IF NOT CAN-FIND(FIRST tt-ped-venda-qry) THEN DO: /* -->> faixa de pedidos */

              RUN searchTag IN hGenXml (INPUT "OrderNumber":U, INPUT getStack(), OUTPUT iId).
              addStack(iId).
                 RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "InitialOrderNumber":U, OUTPUT i-nr-pedido-ini).
                 RUN searchTag IN hGenXml (INPUT "FinalOrderNumber":U, INPUT getStack(), OUTPUT iId).
                 IF iId <> ? THEN
                    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "FinalOrderNumber":U, OUTPUT i-nr-pedido-fim).
              delStack().

              RUN searchTag IN hGenXml (INPUT "ExternalOrderNumber":U, INPUT getStack(), OUTPUT iId).
              addStack(iId).
                 RUN searchTag IN hGenXml (INPUT "InitialExternalOrderNumber":U, INPUT getStack(), OUTPUT iId).
                     RUN getValue IN hGenXml (INPUT iId, OUTPUT c-nr-ped-crm-ini).
                 RUN searchTag IN hGenXml (INPUT "FinalExternalOrderNumber":U, INPUT getStack(), OUTPUT iId).
                 IF iId <> ? THEN RUN getValue IN hGenXml (INPUT iId, OUTPUT c-nr-ped-crm-fim).
                 &if '{&bf_dis_versao_ems}' < '2.05':U &then
                     IF  c-nr-ped-crm-ini = "0":U THEN ASSIGN c-nr-ped-crm-ini = "":U.
                     IF  c-nr-ped-crm-fim = "0":U THEN ASSIGN c-nr-ped-crm-fim = "":U.
                 &endif
              delStack().

              RUN searchTag IN hGenXml (INPUT "Customer":U, INPUT getStack(), OUTPUT iId).
              addStack(iId).
                 RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialCustomerShortName":U, OUTPUT c-nome-abrev-ini).
                 RUN searchTag IN hGenXml (INPUT "FinalCustomerShortName":U, INPUT getStack(), OUTPUT iId).
                 IF iId <> ? THEN
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalCustomerShortName":U, OUTPUT c-nome-abrev-fim).
              delStack().

              RUN searchTag IN hGenXml (INPUT "CustomerOrderNumber":U, INPUT getStack(), OUTPUT iId).
              addStack(iId).
                 RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialCustomerOrderNumber":U, OUTPUT c-nr-pedcli-ini).
                 RUN searchTag IN hGenXml (INPUT "FinalCustomerOrderNumber":U, INPUT getStack(), OUTPUT iId).
                 IF iId <> ? THEN
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalCustomerOrderNumber":U, OUTPUT c-nr-pedcli-fim).
              delStack().

              RUN searchTag IN hGenXml (INPUT "Site":U, INPUT getStack(), OUTPUT iId).
              addStack(iId).
                 RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialSiteID":U, OUTPUT c-cod-estab-ini).
                 RUN searchTag IN hGenXml (INPUT "FinalSiteID":U, INPUT getStack(), OUTPUT iId).
                 IF iId <> ? THEN
                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalSiteID":U, OUTPUT c-cod-estab-fim).
              delStack().

              RUN searchTag IN hGenXml (INPUT "Representative":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialRepresentativeShortName":U, OUTPUT c-no-ab-rep-ini).
                     RUN searchTag IN hGenXml (INPUT "FinalRepresentativeShortName":U, INPUT getStack(), OUTPUT iId).
                     IF iId <> ? THEN
                         RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalRepresentativeShortName":U, OUTPUT c-no-ab-rep-fim).
                  delStack().
              END.
              ELSE ASSIGN c-no-ab-rep-fim = "ZZZZZZZZZZZZ":U.

              RUN searchTag IN hGenXml (INPUT "Priority":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                    RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "InitialPriority":U, OUTPUT i-cod-priori-ini).
                    RUN searchTag IN hGenXml (INPUT "FinalPriority":U, INPUT getStack(), OUTPUT iId).
                    IF iId <> ? THEN
                       RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "FinalPriority":U, OUTPUT i-cod-priori-fim).
                  delStack().
              END.
              ELSE ASSIGN i-cod-priori-fim = 99.

              RUN searchTag IN hGenXml (INPUT "UserOrderType":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialUserOrderType":U, OUTPUT c-tp-pedido-ini).
                     RUN searchTag IN hGenXml (INPUT "FinalUserOrderType":U, INPUT getStack(), OUTPUT iId).
                     IF iId <> ? THEN
                        RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalUserOrderType":U, OUTPUT c-tp-pedido-fim).
                  delStack().
              END.
              ELSE ASSIGN c-tp-pedido-fim = "ZZ":U.

              RUN searchTag IN hGenXml (INPUT "DistributionChannel":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "InitialDistributionChannelCode":U, OUTPUT i-canal-venda-ini).
                     RUN searchTag IN hGenXml (INPUT "FinalDistributionChannelCode":U, INPUT getStack(), OUTPUT iId).
                     IF iId <> ? THEN
                        RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "FinalDistributionChannelCode":U, OUTPUT i-canal-venda-fim).
                  delStack().
              END.
              ELSE ASSIGN i-canal-venda-fim = 999.

              RUN searchTag IN hGenXml (INPUT "RegisterDate":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "InitialRegisterDate":U, OUTPUT d-dt-emissao-ini).
                     RUN searchTag IN hGenXml (INPUT "FinalRegisterDate":U, INPUT getStack(), OUTPUT iId).
                     IF iId <> ? THEN 
                        RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "FinalRegisterDate":U, OUTPUT d-dt-emissao-fim).
                  delStack().
              END.
              ELSE ASSIGN d-dt-emissao-fim = DATE(12,31,9999).

              RUN searchTag IN hGenXml (INPUT "AdditionDate":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "InitialAdditionDate":U, OUTPUT d-dt-implant-ini).
                     RUN searchTag IN hGenXml (INPUT "FinalAdditionDate":U, INPUT getStack(), OUTPUT iId).
                     IF iId <> ? THEN 
                        RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "FinalAdditionDate":U, OUTPUT d-dt-implant-fim).
                  delStack().
              END.
              ELSE ASSIGN d-dt-implant-fim = DATE(12,31,9999).

              RUN searchTag IN hGenXml (INPUT "DeliveryDate":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "InitialDeliveryDate":U, OUTPUT d-dt-entrega-ini).
                     RUN searchTag IN hGenXml (INPUT "FinalDeliveryDate":U, INPUT getStack(), OUTPUT iId).
                     IF iId <> ? THEN 
                        RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "FinalDeliveryDate":U, OUTPUT d-dt-entrega-fim).
                  delStack().
              END.
              ELSE ASSIGN d-dt-entrega-fim = DATE(12,31,9999).

              RUN searchTag IN hGenXml (INPUT "CancellationyDate":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "InitialCancellationDate":U, OUTPUT d-dt-cancela-ini).
                     RUN searchTag IN hGenXml (INPUT "FinalCancellationDate":U, INPUT getStack(), OUTPUT iId).
                     IF iId <> ? THEN 
                        RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "FinalCancellationDate":U, OUTPUT d-dt-cancela-fim).
                  delStack().
              END.
              ELSE ASSIGN d-dt-cancela-fim = DATE(12,31,9999).

              RUN searchTag IN hGenXml (INPUT "OrderType":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN 
                 RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "OrderType":U, OUTPUT i-esp-ped).

              RUN searchTag IN hGenXml (INPUT "OrderStatus":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsOpen":U, OUTPUT l-aberto).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsPartialProcess":U, OUTPUT l-atendido-parc).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsTotalProcess":U, OUTPUT l-atendido-tot).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsSuspended":U, OUTPUT l-suspenso).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsPending":U, OUTPUT l-pendente).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsCanceled":U, OUTPUT l-cancelado).
                  delStack().
              END.

              RUN searchTag IN hGenXml (INPUT "CreditApprovalCurrentStatus":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN DO:
                  addStack(iId).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsNotEvaluated":U, OUTPUT l-nao-avaliado).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsEvaluate":U, OUTPUT l-avaliado).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsApproved":U, OUTPUT l-aprovado).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsNotApproved":U, OUTPUT l-nao-aprovado).
                     RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "IsConfirmationPending":U, OUTPUT l-pendeinfo).
                  delStack().
              END.

              /* Se elemento final nÆo for enviado, considera-se faixa inicial */
              IF i-nr-pedido-fim   = ? THEN ASSIGN i-nr-pedido-fim   = i-nr-pedido-ini.
              IF c-nr-ped-crm-fim  = ? THEN ASSIGN c-nr-ped-crm-fim  = c-nr-ped-crm-ini.
              IF c-nome-abrev-fim  = ? THEN ASSIGN c-nome-abrev-fim  = c-nome-abrev-ini.
              IF c-nr-pedcli-fim   = ? THEN ASSIGN c-nr-pedcli-fim   = c-nr-pedcli-ini.
              IF c-cod-estab-fim   = ? THEN ASSIGN c-cod-estab-fim   = c-cod-estab-ini.
              IF c-no-ab-rep-fim   = ? THEN ASSIGN c-no-ab-rep-fim   = c-no-ab-rep-ini.
              IF i-cod-priori-fim  = ? THEN ASSIGN i-cod-priori-fim  = i-cod-priori-ini.
              IF c-tp-pedido-fim   = ? THEN ASSIGN c-tp-pedido-fim   = c-tp-pedido-ini.
              IF i-canal-venda-fim = ? THEN ASSIGN i-canal-venda-fim = i-canal-venda-ini.
              IF d-dt-emissao-fim  = ? THEN ASSIGN d-dt-emissao-fim  = d-dt-emissao-ini.
              IF d-dt-implant-fim  = ? THEN ASSIGN d-dt-implant-fim  = d-dt-implant-ini.
              IF d-dt-entrega-fim  = ? THEN ASSIGN d-dt-entrega-fim  = d-dt-entrega-ini.
              IF d-dt-cancela-fim  = ? THEN ASSIGN d-dt-cancela-fim  = d-dt-cancela-ini.

          END. 
    delStack(). /* Query */   

    /* Cria mensagem com os pedidos encontrados */
    RUN reset       IN hGenXml.
    RUN setEncoding IN hGenXml ("UTF-8":U).

    RUN addNode     IN hGenXml (0, "ListOfSalesOrders":U, "":U, OUTPUT iRoot).

    FOR EACH tt-ped-venda-qry BY tt-ped-venda-qry.nome-abrev
                              BY tt-ped-venda-qry.nr-pedcli:

         FOR FIRST ped-venda USE-INDEX ch-pedido NO-LOCK WHERE
                   ped-venda.nome-abrev  = tt-ped-venda-qry.nome-abrev AND
                   ped-venda.nr-pedcli   = tt-ped-venda-qry.nr-pedcli  AND
                   ped-venda.log-cotacao = NO:

            /* Cria tags da mensagem de retornos com base nas infornma‡äes do pedido */
            RUN pi-gera-tags.
         END.
    END.

    IF NOT CAN-FIND (FIRST tt-ped-venda-qry) THEN  
        /* Considera faixas informadas */
        FOR EACH ped-venda USE-INDEX ch-pedido NO-LOCK WHERE 
                 ped-venda.nr-pedcli       >= c-nr-pedcli-ini
             AND ped-venda.nr-pedcli       <= c-nr-pedcli-fim
             AND ped-venda.nome-abrev      >= c-nome-abrev-ini
             AND ped-venda.nome-abrev      <= c-nome-abrev-fim
             AND ped-venda.nr-pedido       >= i-nr-pedido-ini
             AND ped-venda.nr-pedido       <= i-nr-pedido-fim    
             AND ped-venda.no-ab-reppri    >= c-no-ab-rep-ini
             AND ped-venda.no-ab-reppri    <= c-no-ab-rep-fim
             AND ped-venda.cod-canal-venda >= i-canal-venda-ini 
             AND ped-venda.cod-canal-venda <= i-canal-venda-fim
             AND ped-venda.cod-estabel     >= c-cod-estab-ini
             AND ped-venda.cod-estabel     <= c-cod-estab-fim
             AND ped-venda.dt-emissao      >= d-dt-emissao-ini
             AND ped-venda.dt-emissao      <= d-dt-emissao-fim
             AND ped-venda.dt-implant      >= d-dt-implant-ini
             AND ped-venda.dt-implant      <= d-dt-implant-fim 
             AND ped-venda.dt-entrega      >= d-dt-entrega-ini
             AND ped-venda.dt-entrega      <= d-dt-entrega-fim
             AND ped-venda.tp-pedido       >= c-tp-pedido-ini
             AND ped-venda.tp-pedido       <= c-tp-pedido-fim
             AND ped-venda.cod-priori      >= i-cod-priori-ini
             AND ped-venda.cod-priori      <= i-cod-priori-fim
             AND ped-venda.esp-ped         =  i-esp-ped
             AND ((ped-venda.cod-sit-ped = 1 AND l-aberto        = YES) OR
                  (ped-venda.cod-sit-ped = 2 AND l-atendido-parc = YES) OR
                  (ped-venda.cod-sit-ped = 3 AND l-atendido-tot  = YES) OR
                  (ped-venda.cod-sit-ped = 4 AND l-pendente      = YES) OR
                  (ped-venda.cod-sit-ped = 5 AND l-suspenso      = YES) OR
                  (IF ped-venda.cod-sit-ped = 6 AND l-cancelado = YES
                   THEN (ped-venda.dt-cancela <= d-dt-cancela-fim
                     AND ped-venda.dt-cancela >= d-dt-cancela-ini)
                   ELSE NO))
             AND ((ped-venda.cod-sit-aval = 1 AND l-nao-avaliado = YES) OR
                  (ped-venda.cod-sit-aval = 2 AND l-avaliado     = YES) OR
                  (ped-venda.cod-sit-aval = 3 AND l-aprovado     = YES) OR
                  (ped-venda.cod-sit-aval = 4 AND l-nao-aprovado = YES) OR
                  (ped-venda.cod-sit-aval = 5 AND l-pendeinfo    = YES))
             AND &if '{&bf_dis_versao_ems}' >= '2.05':U &then
                      ped-venda.nr-pedido-crm >= integer(c-nr-ped-crm-ini)
                  AND ped-venda.nr-pedido-crm <= integer(c-nr-ped-crm-fim)
                 &else 
                       substr(ped-venda.char-2,1,9) >= c-nr-ped-crm-ini 
                   AND substr(ped-venda.char-2,1,9) <= c-nr-ped-crm-fim 
                 &endif
             AND ped-venda.log-cotacao = NO :

            /* Cria tags da mensagem de retornos com base nas infornma‡äes do pedido */
            RUN pi-gera-tags.

        END. /* for each ped-venda */

    RUN generateXML        IN hGenXml (OUTPUT hQueryReturnContent). /* gera XML com os pedidos encontrados */
    &IF "{&mguni_version}" >= "2.071" &THEN
    RUN sendMessage        IN hMessageHandler (INPUT "vd2/SalesOrder_204_001.xsd":U). 
    &ELSE
    RUN sendMessage        IN hMessageHandler (INPUT "vd2/SalesOrder_204_000.xsd":U). 
    &ENDIF
    RUN getReturnStatus    IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    IF NOT pSendSuccess THEN DO: /* Erro na gera‡Æo da mensagem de retorno */
       REPEAT iCount = 1 TO pTotalErrors:

          RUN getError IN hMessageHandler (iCount, OUTPUT pErrorNumber, OUTPUT pErrorType, OUTPUT pErrorDesc ).
          CREATE RowErrors.
          ASSIGN RowErrors.ErrorSequence    = i-cont-err + 1
                 RowErrors.ErrorNumber      = pErrorNumber
                 RowErrors.ErrorType        = pErrorType
                 RowErrors.ErrorSubType     = "Error":U
                 RowErrors.ErrorDescription  = SUBSTRING(pErrorDesc,1,2000)
                 RowErrors.ErrorHelp         = SUBSTRING(pErrorDesc,1,20000)
                 i-cont-err                 = i-cont-err + 1.
       END.
    END.

END PROCEDURE.


PROCEDURE pi-gera-tags:


    FIND emitente WHERE emitente.nome-abrev = ped-venda.nome-abrev
                  AND   emitente.identific <> 2 NO-LOCK NO-ERROR.

    FIND FIRST ped-item OF ped-venda
         WHERE LOOKUP(string(ped-item.cod-sit-item),c-sit-item) <> 0 NO-LOCK NO-ERROR.

    IF AVAIL ped-item AND AVAIL emitente THEN DO:

       RUN addNode IN hGenXml (iRoot, "SalesOrder":U, "":U, OUTPUT iFirstId).
       RUN pi-informacoes-pedido. /* axsvd003.i */
    END.



END PROCEDURE.


