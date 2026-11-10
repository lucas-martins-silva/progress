CREATE tt-item.
ASSIGN tt-item.it-codigo = ItemCode.

IF PurchaseManufacturyDefinition = "comprado" THEN
    ASSIGN tt-item.compr-fabric = 1.
ELSE
    ASSIGN tt-item.compr-fabric = 2.


RUN cep/ceapi016.p (INPUT TABLE tt-item).
    
