DEFINE TEMP-TABLE ttPurchaseOrderLine012 NO-UNDO
     FIELD DeliveryDate              AS date INITIAL ?  /*Data Entrega. (Uso Interno: Campo = prazo-compra.data-entrega) */
     FIELD ItemCode                  AS CHARACTER INITIAL ?  /*C¢digo do Item. (Uso Interno: Campo = ordem-compra.it-codigo) */
     FIELD ItemDescription           AS CHARACTER INITIAL ?  /*Descri‡Æo do item. (Uso Interno: Campo = item.desc-item)*/
     FIELD POLineNumber              AS integer INITIAL ?  /*N£mero da Ordem de Compra. (Uso interno: Campo = movind.ordem-compra.numero-ordem)*/
     FIELD PriceVendor               AS decimal INITIAL ?  /*Pre‡o  Fornecedor (Uso interno: Campo = ordem-compra.preco-fornec)*/
     FIELD Quantity                  AS decimal INITIAL ?  /*Quantidade (Uso Interno: Campo = ordem-compra.qt-solic) */
     FIELD ttPurchaseOrderLineID     AS INTEGER INITIAL ?
     FIELD UnitPrice                 LIKE cotacao-item.preco-unit INITIAL ?  /*Pre‡o Unit rio (Uso interno: Campo = ordem-compra.preco-unit)*/
     FIELD UnitPriceVendor           AS decimal INITIAL ?  /*Pre‡o Unit rio Fornecedor (Uso interno: Campo = ordem-compra.pre-unit-for)*/
     field POLineNumberWebb          as character
     field CurrencyID                as integer
     INDEX ixttPurchaseOrderLineID IS PRIMARY UNIQUE ttPurchaseOrderLineID ASCENDING.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro  AS character INITIAL ?.

def temp-table tt-pedido-compr no-undo like pedido-compr.
