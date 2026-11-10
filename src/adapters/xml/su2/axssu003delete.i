PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM cEvent AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM ContactName AS CHARACTER INITIAL ? NO-UNDO.  /*Contato. Deve ser um contato relacionado ao fornecedor do pedido (ordem-compra.cod-emitente) (Uso Interno: Campo = mgadm.cont-emit.nome)*/
DEFINE INPUT PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM EmailAddress_00 AS CHARACTER INITIAL ? NO-UNDO.  /*Endere‡o de e-mail da pessoa de contato (uso Interno: Campo = mgadm.cont-emit.e-mail)*/
DEFINE INPUT PARAM PhoneNumber_00 AS CHARACTER INITIAL ? NO-UNDO.  /*Telefone da pessoa de contato (Uso Interno: Campo = mgadm.cont-emit.telefone)*/
DEFINE INPUT PARAM POLineNumber AS integer INITIAL ? NO-UNDO.  /*Descri‡Æo: N£mero da Ordem de Compra (Uso Interno: Campo = cotacao-item.numero-ordem)*/
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
DEFINE INPUT PARAM VendorName AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.nome-emit)*/
DEFINE INPUT PARAM VendorNumber AS integer INITIAL ? NO-UNDO.  /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.cod-emitente)*/
DEFINE INPUT PARAM VendorShortName AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do Fornecedor. ( Uso Interno: Campo= emitente.nome-abrev)*/
DEFINE INPUT PARAM VendorTaxID AS CHARACTER INITIAL ? NO-UNDO.  /*CGC ou CPF do fornecedor (Uso Interno: Campo = emitente.cgc)*/
DEFINE INPUT PARAM QuotationPortal AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM QuotationItemPortal AS CHARACTER INITIAL ? NO-UNDO.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */


    ASSIGN QuotationNumberPortal     = QuotationPortal
           QuotationItemNumberPortal = QuotationItemPortal.

     RUN PIDelete
     (
          INPUT cEvent,
          INPUT ContactName,
          INPUT cTranAction,
          INPUT EmailAddress_00,
          INPUT PhoneNumber_00,
          INPUT POLineNumber,
          OUTPUT TABLE tt_log_erro,
          INPUT VendorName,
          INPUT VendorNumber,
          INPUT VendorShortName,
          INPUT VendorTaxID
      ).


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



