/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSVD003A.P 2.00.00.002 }  /*** 012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsvd003a MAX}
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
    File        : AXSVD003a.p
    Purpose     :   ENVIO INFORMA€åES VENDOR
                 /* SUB-PROGRAMA - ADAPTER DE PEDIDO DE VENDA */

    Syntax      :

    Description : ENVIO DE INFORMA€åES DO MàDULO VENDOR
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
def new global shared var iFirstId          as int no-undo.
def new global shared var iId               as int no-undo.

def new global shared var iListPaymentCodes as int no-undo.
def new global shared var iVendorInfo       as int no-undo.

/* Variaveis locais */
def var i-cont as int no-undo.
def var l-cond-cli-aux as LOG INIT NO no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***************************  Main Block  *************************** */
find ped-venda where rowid(ped-venda) = pRowidPedVenda no-lock no-error.

/*FIND pd-vendor WHERE
     pd-vendor.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
 IF AVAIL pd-vendor THEN DO:
  /* VendorInformation */
  RUN addNode IN hGenXml (iFirstId,
                          "VendorInformation":U,
                          "",
                          OUTPUT iVendorInfo).

  IF pd-vendor.taxa-cliente <> 0 THEN
   RUN addNodeDec IN hGenXml (iVendorInfo,
                              "FinancialRate":U,
                               pd-vendor.taxa-cliente * 100,  /* transformado p/ percentual conforme PD4000 */
                               OUTPUT iId).

  IF pd-vendor.mo-cliente <> 0 THEN
   RUN addNodeDec IN hGenXml (iVendorInfo,
                              "IndexDealtWithCustomer":U,
                               pd-vendor.mo-cliente,
                               OUTPUT iId).

  IF pd-vendor.cod-cond-cli <> 0 THEN
   RUN addNodeDec IN hGenXml (iVendorInfo,
                              "CustomerPaymentPlanCode":U,
                               pd-vendor.cod-cond-cli,
                               OUTPUT iId).

  IF pd-vendor.cod-cond-cli-aux[1] <> 0 THEN DO:

     ASSIGN  l-cond-cli-aux = YES.
             i-cont = 1.
     /* ListOfAuxiliaryCustomerPaymentPlanCodes */
     RUN addNode IN hGenXml (iVendorInfo,
                             "ListOfAuxiliaryCustomerPaymentPlanCodes":U,
                             "",
                             OUTPUT iListPaymentCodes).

     DO WHILE l-cond-cli-aux:
      IF pd-vendor.cod-cond-cli-aux[i-cont] <> 0 THEN DO:
       RUN addNodeDec IN hGenXml (iListPaymentCodes,
                                  "AuxiliaryCustomerPaymentPlanCode":U,
                                   pd-vendor.cod-cond-cli-aux[i-cont],
                                  OUTPUT iId).
       ASSIGN i-cont = i-cont + 1.
      END.
      ELSE ASSIGN l-cond-cli-aux = NO.
     END.
  END.
   
  IF pd-vendor.dias-base <> 0 THEN
   RUN addNodeDec IN hGenXml (iVendorInfo,
                              "GraceDaysForVendorContractClosing":U,
                               pd-vendor.dias-base,
                               OUTPUT iId).

  IF pd-vendor.data-base <> ? THEN
   RUN addNodeDate IN hGenXml (iVendorInfo,
                              "BaseDate":U,
                               pd-vendor.data-base,
                               OUTPUT iId).

  IF pd-vendor.vl-equal-prov <> 0 THEN
   RUN addNodeDec IN hGenXml (iVendorInfo,
                              "ProvisionedEqualization":U,
                               pd-vendor.vl-equal-prov,
                               OUTPUT iId).

 END.
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
