PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM pInvoiceDocumentRowID AS ROWID NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE tt_log_erro       NO-ERROR.
EMPTY TEMP-TABLE ttInvoiceDocument NO-ERROR.

FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = pInvoiceDocumentRowID NO-LOCK NO-ERROR.

IF AVAIL nota-fiscal THEN DO:

   FOR FIRST estabelec FIELDS (nome) NO-LOCK WHERE
             estabelec.cod-estabel = nota-fiscal.cod-estabel: END.

   FOR FIRST emitente FIELDS (nome-abrev cgc) NO-LOCK WHERE
             emitente.cod-emitente = nota-fiscal.cod-emitente: END.

   FOR FIRST natur-oper FIELDS (denominacao) NO-LOCK WHERE
             natur-oper.nat-operacao = nota-fiscal.nat-operacao: END.

   CREATE ttInvoiceDocument.
   ASSIGN ttInvoiceDocument.DocumentSeries	            = nota-fiscal.serie
          ttInvoiceDocument.DocumentNumber           	= nota-fiscal.nr-nota-fis
          ttInvoiceDocument.FiscalOperationCode      	= nota-fiscal.nat-operacao
          ttInvoiceDocument.CustomerShortName           = nota-fiscal.nome-ab-cli
          ttInvoiceDocument.CustomerTaxID	            = nota-fiscal.cgc
          ttInvoiceDocument.CustomerStateTaxID      	= nota-fiscal.ins-estadual
          ttInvoiceDocument.CustomerID	                = nota-fiscal.cod-emitente
          ttInvoiceDocument.CustomerOrderNumber	        = nota-fiscal.nr-pedcli
          ttInvoiceDocument.DocumentType            	= nota-fiscal.esp-docto
          ttInvoiceDocument.SiteID                  	= nota-fiscal.cod-estabel.

          IF AVAIL estabelec THEN
             ASSIGN ttInvoiceDocument.SiteDescription = estabelec.nome.

          IF AVAIL emitente THEN
             ASSIGN ttInvoiceDocument.SiteShortName	  = emitente.nome-abrev
                    ttInvoiceDocument.SiteTaxID	      = emitente.cgc.

          IF AVAIL natur-oper THEN
             ASSIGN ttInvoiceDocument.FiscalOperationDescription = natur-oper.denominacao.


   RUN PIDelete ( INPUT "del":U,                  /* TranAction */
                  INPUT TABLE ttInvoiceDocument,  /* Informa‡äes da nota fiscal */
                  OUTPUT TABLE tt_log_erro ).     /* Mensagens de Erro */

END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



