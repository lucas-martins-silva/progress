/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSVD003B 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsvd003b MAX}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXSVD003B.p
    Purpose     :  ENVIO INFORMA€åES COMEX
                /* SUB-PROGRAMA - ADAPTER DE PEDIDO DE VENDA */

    Syntax      :

    Description : ENVIO DE INFORMA€åES DO MàDULO DE COMRCIO EXTERIOR
    Author(s)   : Eliza Fernandes Corrˆa - log1465
    CREATEd     : 23/12/2003 15:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Parƒmetros de entrada */
DEF INPUT PARAM pRowidPedVenda AS ROWID NO-UNDO.

/* Vari veis Globais */
DEF NEW GLOBAL SHARED VAR hGenXml AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
def new global shared var iFirstId           as int no-undo.
def new global shared var iId                as int no-undo.

def new global shared var iArrival           as int no-undo.
def new global shared var iConsignee         as int no-undo.
def new global shared var iControlPoint      as int no-undo.
def new global shared var iCurrency          as int no-undo.
def new global shared var iDeclaration       as int no-undo.
def new global shared var iDispatch          as int no-undo.
def new global shared var iExpense           as int no-undo.
def new global shared var iExpensePriceTable as int no-undo.
def new global shared var iExpenseType       as int no-undo.
def new global shared var iExpenseVendor     as int no-undo.
def new global shared var iExportInfo        as int no-undo.
def new global shared var iItinerary         as int no-undo.
def new global shared var iLanding           as int no-undo.
def new global shared var iListExpenses      as int no-undo.
def new global shared var iListMarks         as int no-undo.
def new global shared var iMark              as int no-undo.
def new global shared var iNotifying         as int no-undo.
def new global shared var iOrderExport       as int no-undo.
def new global shared var iPaymentPlan       as int no-undo.
def new global shared var iShipment          as int no-undo.

/* Variaveis locais */
def var i-cont as INT no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***************************  Main Block  *************************** */
{cdp/cdcfgdis.i}

find ped-venda where rowid(ped-venda) = pRowidPedVenda no-lock no-error.
                  
FIND ped-venda-cex WHERE
     ped-venda-cex.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
 IF AVAIL ped-venda-cex THEN DO:
  /* OrderExport */
  RUN addNode IN hGenXml (iExportInfo,
                          "OrderExport":U,
                          "",
                          OUTPUT iOrderExport).

  RUN addNode IN hGenXml (iOrderExport,
                          "Language":U,
                           ped-venda-cex.cod-idioma,
                           OUTPUT iId).

  RUN addNode IN hGenXml (iOrderExport,
                          "Incoterm":U,
                           ped-venda-cex.cod-incoterm,
                           OUTPUT iId).

  &if '{&BF_DIS_VERSAO_EMS}' >= "2.06":U &then
    IF ped-venda-cex.dt-val-prof <> ? AND string(ped-venda-cex.dt-val-prof) <> "" THEN
          RUN addNodeDate IN hGenXml (iOrderExport,
                                      "ProformaValidityDate":U,
                                       ped-venda-cex.dt-val-prof,
                                       OUTPUT iId).
  &else
    IF ped-venda-cex.data-1 <> ? AND string(ped-venda-cex.data-1) <> "" THEN
        RUN addNodeDate IN hGenXml (iOrderExport,
                                    "ProformaValidityDate":U,
                                     ped-venda-cex.data-1,
                                     OUTPUT iId).
  &endif

  RUN addNodeDec IN hGenXml (iOrderExport,
                              "VolumeAmount":U,
                               &if '{&BF_DIS_VERSAO_EMS}' >= "2.06" &then
                                    ped-venda-cex.volume
                               &else
                                    ped-venda-cex.dec-1
                               &endif,

                               OUTPUT iId).
  /* Declaration */ 
  &if '{&BF_DIS_VERSAO_EMS}' >= "2.06" &then
       FIND FIRST decl-padrao WHERE
                  decl-padrao.de-codigo = ped-venda-cex.cod-decl-padrao NO-LOCK NO-ERROR.
         IF AVAIL decl-padrao AND
                  decl-padrao.descricao <> "" THEN DO:
             RUN addNode IN hGenXml (iOrderExport,
                                     "Declaration":U,
                                     "",
                                     OUTPUT iDeclaration).

             RUN addNodeDec IN hGenXml (iDeclaration,
                                        "DeclarationCode":U,
                                         ped-venda-cex.cod-decl-padrao,
                                         OUTPUT iId).

             RUN addNode IN hGenXml (iDeclaration,
                                     "DeclarationDescription":U,
                                      decl-padrao.descricao,
                                      OUTPUT iId).

         END.
  &else
       FIND FIRST decl-padrao WHERE
                  decl-padrao.de-codigo = INT(substr(ped-venda-cex.char-1,1,6))
                  NO-LOCK NO-ERROR.
         IF AVAIL decl-padrao AND
                  decl-padrao.descricao <> "" THEN DO:
           RUN addNode IN hGenXml (iOrderExport,
                                   "Declaration":U,
                                   "",
                                   OUTPUT iDeclaration).

           RUN addNodeDec IN hGenXml (iDeclaration,
                                      "DeclarationCode":U,
                                       INT(substr(ped-venda-cex.char-1,1,6)),
                                       OUTPUT iId).

           RUN addNode IN hGenXml (iDeclaration,
                                   "DeclarationDescription":U,
                                    decl-padrao.descricao,
                                    OUTPUT iId).

         END.
  &endif
  /* Consignee */
  &if '{&BF_DIS_VERSAO_EMS}' >= "2.06" &then
       FIND FIRST emitente WHERE
                  emitente.cod-emitente = ped-venda-cex.cod-emitente NO-LOCK NO-ERROR.
         IF AVAIL emitente AND
                  emitente.nome-emit <> "" THEN DO:
             RUN addNode IN hGenXml (iOrderExport,
                                     "Consignee":U,
                                     "",
                                     OUTPUT iConsignee).

             RUN addNodeDec IN hGenXml (iConsignee,
                                        "ConsigneeCode":U,
                                         ped-venda-cex.cod-consign,
                                         OUTPUT iId).

             RUN addNode IN hGenXml (iConsignee,
                                     "ConsigneeName":U,
                                      emitente.nome-emit,
                                      OUTPUT iId).

         END.
  &else
       FIND FIRST emitente WHERE
                  emitente.cod-emitente = ped-venda-cex.cod-emitente NO-LOCK NO-ERROR.
         IF AVAIL emitente AND
                  emitente.nome-emit <> "" THEN DO:
           RUN addNode IN hGenXml (iOrderExport,
                                   "Consignee":U,
                                   "",
                                   OUTPUT iConsignee).

           RUN addNodeDec IN hGenXml (iConsignee,
                                      "ConsigneeCode":U,
                                       ped-venda-cex.int-1,
                                       OUTPUT iId).

           RUN addNode IN hGenXml (iConsignee,
                                   "ConsigneeName":U,
                                    emitente.nome-emit,
                                    OUTPUT iId).

         END.
  &endif
  /* Notifying */
  &if '{&BF_DIS_VERSAO_EMS}' >= "2.06" &then
       FIND FIRST emitente WHERE
                  emitente.cod-emitente = ped-venda-cex.cod-emitente NO-LOCK NO-ERROR.
         IF AVAIL emitente AND 
                  emitente.nome-emit <> "" THEN DO:
             RUN addNode IN hGenXml (iOrderExport,
                                     "Notifying":U,
                                     "",
                                     OUTPUT iNotifying).

             RUN addNodeDec IN hGenXml (iNotifying,
                                        "NotifyingCode":U,
                                         ped-venda-cex.cod-notif,
                                         OUTPUT iId).

             RUN addNode IN hGenXml (iNotifying,
                                     "NotifyingName":U,
                                      emitente.nome-emit,
                                      OUTPUT iId).

         END.
  &else
       FIND FIRST emitente WHERE
                  emitente.cod-emitente = ped-venda-cex.cod-emitente NO-LOCK NO-ERROR.
         IF AVAIL emitente AND
                  emitente.nome-emit <> "" THEN DO:
           RUN addNode IN hGenXml (iOrderExport,
                                   "Notifying":U,
                                   "",
                                   OUTPUT iNotifying).

           RUN addNodeDec IN hGenXml (iNotifying,
                                      "NotifyingCode":U,
                                       ped-venda-cex.int-2,
                                       OUTPUT iId).

           RUN addNode IN hGenXml (iNotifying,
                                   "NotifyingName":U,
                                    emitente.nome-emit,
                                    OUTPUT iId).

         END.
  &endif
  /* Itinerary */
  RUN addNode IN hGenXml (iOrderExport,
                          "Itinerary":U,
                          "",
                          OUTPUT iItinerary).

  RUN addNodeDec IN hGenXml (iItinerary,
                             "ItineraryCode":U,
                              ped-venda-cex.cod-itiner,
                              OUTPUT iId).

  FIND FIRST itinerario WHERE
             itinerario.cod-itiner = ped-venda-cex.cod-itiner NO-LOCK NO-ERROR.
    IF AVAIL itinerario THEN 
      RUN addNode IN hGenXml (iItinerary,
                              "ItineraryDescription":U,
                               itinerario.descricao,
                               OUTPUT iId).
  /* Dispatch */
  FIND FIRST pto-contr WHERE
             pto-contr.cod-pto-contr = ped-venda-cex.pto-despacho NO-LOCK NO-ERROR.
    IF AVAIL pto-contr AND 
             pto-contr.descricao <> ""        AND 
             pto-contr.unid-referencial <> 0  AND
             pto-contr.narrativa <> ""        THEN DO:
          RUN addNode IN hGenXml (iItinerary,
                                  "Dispatch":U,
                                  "",
                                  OUTPUT iDispatch).

          RUN addNodeDec IN hGenXml (iDispatch,
                                     "DispatchPointID":U,
                                      ped-venda-cex.pto-despacho,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iDispatch,
                                  "DispatchPointDescription":U,
                                   pto-contr.descricao,
                                   OUTPUT iId).

          RUN addNodeDec IN hGenXml (iDispatch,
                                     "DispatchPointReferencialUnit":U,
                                      pto-contr.unid-referencial,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iDispatch,
                                  "DispatchPointComments":U,
                                   pto-contr.narrativa,
                                   OUTPUT iId).
    END.
  /* Shipment */
  FIND FIRST pto-contr WHERE
             pto-contr.cod-pto-contr = ped-venda-cex.pto-embarque NO-LOCK NO-ERROR.
    IF AVAIL pto-contr AND 
             pto-contr.descricao <> ""        AND 
             pto-contr.unid-referencial <> 0  AND
             pto-contr.narrativa <> ""        THEN DO:
          RUN addNode IN hGenXml (iItinerary,
                                  "Shipment":U,
                                  "",
                                  OUTPUT iShipment).

          RUN addNodeDec IN hGenXml (iShipment,
                                     "ShipmentPointID":U,
                                      ped-venda-cex.pto-embarque,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iShipment,
                                  "ShipmentPointDescription":U,
                                   pto-contr.descricao,
                                   OUTPUT iId).

          RUN addNodeDec IN hGenXml (iShipment,
                                     "ShipmentPointReferencialUnit":U,
                                      pto-contr.unid-referencial,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iShipment,
                                  "ShipmentPointComments":U,
                                   pto-contr.narrativa,
                                   OUTPUT iId).
    END.
  /* Landing */
  FIND FIRST pto-contr WHERE
             pto-contr.cod-pto-contr = ped-venda-cex.pto-desembarque NO-LOCK NO-ERROR.
    IF AVAIL pto-contr AND 
             pto-contr.descricao <> ""        AND 
             pto-contr.unid-referencial <> 0  AND
             pto-contr.narrativa <> ""        THEN DO:
          RUN addNode IN hGenXml (iItinerary,
                                  "Landing":U,
                                  "",
                                  OUTPUT iLanding).

          RUN addNodeDec IN hGenXml (iLanding,
                                     "LandingPointID":U,
                                      ped-venda-cex.pto-desembarque,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iLanding,
                                  "LandingPointDescription":U,
                                   pto-contr.descricao,
                                   OUTPUT iId).

          RUN addNodeDec IN hGenXml (iLanding,
                                     "LandingPointReferencialUnit":U,
                                      pto-contr.unid-referencial,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iLanding,
                                  "LandingPointComments":U,
                                   pto-contr.narrativa,
                                   OUTPUT iId).
    END.
  /* Arrival */
  FIND FIRST pto-contr WHERE
             pto-contr.cod-pto-contr = ped-venda-cex.pto-chegada NO-LOCK NO-ERROR.
    IF AVAIL pto-contr AND 
             pto-contr.descricao <> ""        AND 
             pto-contr.unid-referencial <> 0  AND
             pto-contr.narrativa <> ""        THEN DO:
          RUN addNode IN hGenXml (iItinerary,
                                  "Arrival":U,
                                  "",
                                  OUTPUT iArrival).

          RUN addNodeDec IN hGenXml (iArrival,
                                     "ArrivalPointID":U,
                                      ped-venda-cex.pto-chegada,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iArrival,
                                  "ArrivalPointDescription":U,
                                   pto-contr.descricao,
                                   OUTPUT iId).

          RUN addNodeDec IN hGenXml (iArrival,
                                     "ArrivalPointReferencialUnit":U,
                                      pto-contr.unid-referencial,
                                      OUTPUT iId).

          RUN addNode IN hGenXml (iArrival,
                                  "ArrivalPointComments":U,
                                   pto-contr.narrativa,
                                   OUTPUT iId).
    END.

  IF ped-venda-cex.marca-1 <> "" OR
     ped-venda-cex.marca-2 <> "" OR
     ped-venda-cex.marca-3 <> "" OR
     ped-venda-cex.marca-4 <> "" OR
     ped-venda-cex.marca-5 <> "" THEN DO:
      /* ListMarks */
      RUN addNode IN hGenXml (iOrderExport,
                              "ListOfMarks":U,
                              "",
                              OUTPUT iListMarks).
    
      IF ped-venda-cex.marca-1 <> "" THEN DO:
       /* Mark */
       RUN addNode IN hGenXml (iListMarks,
                               "Mark":U,
                               "",
                               OUTPUT iMark).
    
       RUN addNodeDec IN hGenXml (iMark,
                                  "MarkSequence":U,
                                   1,
                                   OUTPUT iId).
    
       RUN addNode IN hGenXml (iMark,
                               "MarkDescription":U,
                                ped-venda-cex.marca-1,
                                OUTPUT iId).         
      END.
      IF ped-venda-cex.marca-2 <> "" THEN DO:
       /* Mark */
       RUN addNode IN hGenXml (iListMarks,
                               "Mark":U,
                               "",
                               OUTPUT iMark).
    
       RUN addNodeDec IN hGenXml (iMark,
                                  "MarkSequence":U,
                                   2,
                                   OUTPUT iId).
    
       RUN addNode IN hGenXml (iMark,
                               "MarkDescription":U,
                                ped-venda-cex.marca-2,
                                OUTPUT iId).         
      END.
      IF ped-venda-cex.marca-3 <> "" THEN DO:
       /* Mark */
       RUN addNode IN hGenXml (iListMarks,
                               "Mark":U,
                               "",
                               OUTPUT iMark).
    
       RUN addNodeDec IN hGenXml (iMark,
                                  "MarkSequence":U,
                                   3,
                                   OUTPUT iId).
    
       RUN addNode IN hGenXml (iMark,
                               "MarkDescription":U,
                                ped-venda-cex.marca-3,
                                OUTPUT iId).         
      END.
      IF ped-venda-cex.marca-4 <> "" THEN DO:
         /* Mark */
         RUN addNode IN hGenXml (iListMarks,
                                 "Mark":U,
                                 "",
                                 OUTPUT iMark).
    
         RUN addNodeDec IN hGenXml (iMark,
                                    "MarkSequence":U,
                                     4,
                                     OUTPUT iId).
    
         RUN addNode IN hGenXml (iMark,
                                 "MarkDescription":U,
                                  ped-venda-cex.marca-4,
                                  OUTPUT iId).         
      END.
      IF ped-venda-cex.marca-5 <> "" THEN DO:
      /* Mark */
      RUN addNode IN hGenXml (iListMarks,
                               "Mark":U,
                               "",
                               OUTPUT iMark).
    
      RUN addNodeDec IN hGenXml (iMark,
                                  "MarkSequence":U,
                                   5,
                                   OUTPUT iId).
    
      RUN addNode IN hGenXml (iMark,
                               "MarkDescription":U,
                                ped-venda-cex.marca-5,
                                OUTPUT iId).         
      END.
  END.

  FIND FIRST ped-venda-desp WHERE
             ped-venda-desp.num-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
   IF AVAIL  ped-venda-desp THEN DO:
    /* ListOfExpenses */
    RUN addNode IN hGenXml (iOrderExport,
                            "ListOfExpenses":U,
                            "",
                            OUTPUT iListExpenses).

     FOR EACH ped-venda-desp NO-LOCK WHERE
              ped-venda-desp.num-pedido = ped-venda.nr-pedido:
     /* Expense */
     RUN addNode IN hGenXml (iListExpenses,
                             "Expense":U,
                             "",
                             OUTPUT iExpense).
     /* ControlPoint */
     RUN addNode IN hGenXml (iExpense,
                             "ControlPoint":U,
                             "",
                             OUTPUT iControlPoint).

     RUN addNodeDec IN hGenXml (iControlPoint,
                                "ControlPointID":U,
                                 ped-venda-desp.cod-pto-contr,
                                 OUTPUT iId).

     FIND FIRST pto-contr WHERE
                pto-contr.cod-pto-contr = ped-venda-desp.cod-pto-contr NO-LOCK NO-ERROR.
       IF AVAIL pto-contr THEN
          RUN addNode IN hGenXml (iControlPoint,
                                  "ControlPointDescription":U,
                                   pto-contr.descricao,
                                   OUTPUT iId).

      RUN addNodeDec IN hGenXml (iControlPoint,
                                 "Sequence":U,
                                  ped-venda-desp.sequencia,
                                  OUTPUT iId).
     /* ExpenseType */
     RUN addNode IN hGenXml (iExpense,
                             "ExpenseType":U,
                             "",
                             OUTPUT iExpenseType).

     RUN addNodeDec IN hGenXml (iExpenseType,
                                "ExpenseTypeCode":U,
                                 ped-venda-desp.cdn-despes,
                                 OUTPUT iId).

     FIND FIRST desp-imp WHERE
                desp-imp.cod-desp = ped-venda-desp.cdn-despes NO-LOCK NO-ERROR.
       IF AVAIL desp-imp THEN
         RUN addNode IN hGenXml (iExpenseType,
                                 "ExpenseTypeDescription":U,
                                  desp-imp.descricao,
                                  OUTPUT iId).
     /* ExpenseVendor */
     RUN addNode IN hGenXml (iExpense,
                             "ExpenseVendor":U,
                             "",
                             OUTPUT iExpenseVendor).

     RUN addNodeDec IN hGenXml (iExpenseVendor,
                                "VendorCode":U,
                                 ped-venda-desp.cod-emitente-desp,
                                 OUTPUT iId).

     FIND FIRST emitente WHERE
                emitente.cod-emitente = ped-venda-desp.cod-emitente NO-LOCK NO-ERROR.
       IF AVAIL emitente THEN
         RUN addNode IN hGenXml (iExpenseVendor,
                                 "VendorName":U,
                                  emitente.nome-emit,
                                  OUTPUT iId).

     IF ped-venda-desp.contato <> "" THEN
      RUN addNode IN hGenXml (iExpenseVendor,
                              "ContactName":U,
                               ped-venda-desp.contato,
                               OUTPUT iId).

     RUN addNodeDec IN hGenXml (iExpense,
                                "ExpenseValue":U,
                                 ped-venda-desp.val-despes,
                                 OUTPUT iId).
     /* Currency */
     RUN addNode IN hGenXml (iExpense,
                              "Currency":U,
                              "",
                              OUTPUT iCurrency).

     RUN addNodeDec IN hGenXml (iCurrency,
                                 "CurrencyID":U,
                                  ped-venda-desp.mo-codigo,
                                  OUTPUT iId).

     FIND FIRST moeda WHERE
                moeda.mo-codigo = ped-venda-desp.mo-codigo NO-LOCK NO-ERROR.
       IF AVAIL moeda THEN DO:
        RUN addNode IN hGenXml (iCurrency,
                                 "CurrencyDescription":U,
                                  moeda.descricao,
                                  OUTPUT iId).

        RUN addNode IN hGenXml (iCurrency,
                                 "CurrencySign":U,
                                  moeda.sigla,
                                  OUTPUT iId).
       END.

     IF ped-venda-desp.cdn-classif-desp <> 0 THEN
      RUN addNode IN hGenXml (iExpense,
                              "ExpenseClassification":U,
                               ped-venda-desp.cdn-classif-desp,
                               OUTPUT iId).  

     RUN addNodeLog IN hGenXml (iExpense,
                                "IsExpenseConfirmed":U,
                                 ped-venda-desp.log-confirmada,
                                 OUTPUT iId).

     RUN addNodeLog IN hGenXml (iExpense,
                                "IsExpenseIncludedOnSalesPrice":U,
                                 ped-venda-desp.log-forma-preco,
                                 OUTPUT iId).

     RUN addNodeLog IN hGenXml (iExpense,
                                "IsFinancialRateIncludedOnSalesPrice":U,
                                 ped-venda-desp.log-tax-financ,
                                 OUTPUT iId).

     IF ped-venda-desp.val-perc-tax <> 0 THEN
      RUN addNodeDec IN hGenXml (iExpense,
                                 "FinancialRatePercentage":U,
                                  ped-venda-desp.val-perc-tax,
                                  OUTPUT iId).

     IF ped-venda-desp.num-dias-tax <> 0 THEN
      RUN addNodeDec IN hGenXml (iExpense,
                                 "FinancialRateDays":U,
                                  ped-venda-desp.num-dias-tax,
                                  OUTPUT iId).

     IF ped-venda-desp.cod-cond-pag <> 0 THEN DO:
      /* PaymentPlan */
      RUN addNode IN hGenXml (iExpense,
                              "PaymentPlan":U,
                              "",
                              OUTPUT iPaymentPlan).

      RUN addNodeDec IN hGenXml (iPaymentPlan,
                                 "PaymentPlanCode":U,
                                  ped-venda-desp.cod-cond-pag,
                                  OUTPUT iId).
      FIND FIRST cond-pagto WHERE
                 cond-pagto.cod-cond-pag = ped-venda-desp.cod-cond-pag NO-LOCK NO-ERROR.
        IF AVAIL cond-pagto THEN 
         RUN addNode IN hGenXml (iPaymentPlan,
                                 "PaymentPlanDescription":U,
                                  cond-pagto.descricao,
                                  OUTPUT iId).
     END.

     IF ped-venda-desp.val-perc-desc <> 0 THEN
      RUN addNodeDec IN hGenXml (iExpense,
                                  "DiscountPercentage":U,
                                   ped-venda-desp.val-perc-desc,
                                   OUTPUT iId).
     IF ped-venda-desp.val-min-desc <> 0 THEN
      RUN addNodeDec IN hGenXml (iExpense,
                                  "MinimumDiscountValue":U,
                                   ped-venda-desp.val-min-desc,
                                   OUTPUT iId).
     IF ped-venda-desp.val-min-despes <> 0 THEN
      RUN addNodeDec IN hGenXml (iExpense,
                                  "MinimunExpenseValue":U,
                                   ped-venda-desp.val-min-despes,
                                   OUTPUT iId).
     IF ped-venda-desp.dat-cotac-despes <> ? THEN
      RUN addNodeDate IN hGenXml (iExpense,
                                  "ExpenseQuotationDate":U,
                                   ped-venda-desp.dat-cotac-despes,
                                   OUTPUT iId).

     IF ped-venda-desp.nr-tab <> "" THEN DO:
      /* ExpensePriceTable */
      RUN addNode IN hGenXml (iExpense,
                              "ExpensePriceTable":U,
                              "",
                              OUTPUT iExpensePriceTable).

      RUN addNode IN hGenXml (iExpensePriceTable,
                               "ExpensePriceTableCode":U,
                                ped-venda-desp.nr-tab,
                                OUTPUT iId).

      FIND FIRST tb-pr-cex WHERE
                 tb-pr-cex.nr-tab = ped-venda-desp.nr-tab NO-LOCK NO-ERROR.
        IF AVAIL tb-pr-cex THEN
         RUN addNode IN hGenXml (iExpensePriceTable,
                                  "ExpensePriceTableDescription":U,
                                   tb-pr-cex.descricao,
                                   OUTPUT iId).
     END.

     END. 
   END. 
 
 END. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
