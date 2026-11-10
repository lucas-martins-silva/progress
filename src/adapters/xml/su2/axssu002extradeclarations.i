DEFINE VAR cEvent          AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranAction     AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR PONumber        AS INTEGER   INITIAL ? NO-UNDO.   /*Número do pedido (Uso Interno: Campo = ordem-compra.num-pedido)*/
DEFINE VAR POLineNumber_00 AS INTEGER   INITIAL ? NO-UNDO.  /*Descrição: Número da Ordem de Compra (Uso Interno: Campo = ordem-compra.numero-ordem)*/
DEFINE VAR VendorName_00   AS CHARACTER INITIAL ? NO-UNDO.  /*Nome do fornecedor (Uso Interno: Campo = emitente.nome-emit)*/
DEFINE VAR VendorNumber_00 AS INTEGER   INITIAL ? NO-UNDO.  /*Código do Fornecedor (Uso Interno: Campo = ordem-compra.cod-emitente)*/
DEFINE VAR VendorTaxID_00  AS CHARACTER INITIAL ? NO-UNDO.  /*CGC do Fornecedor (Uso Interno: Campo = emitente.cgc)*/
