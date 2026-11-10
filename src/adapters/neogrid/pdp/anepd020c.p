/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD020C 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD020C MPD}
&ENDIF

/********************************************************************************
** Programa : anepd004.p
** Funcao   : Sender de Simula‡Æo de Estoques
** Data     : 03/2006
********************************************************************************/

{adapters/neogrid/include/anein004.i}

/* Header dos Itens */
DEF TEMP-TABLE ttHeaderItem NO-UNDO
    FIELD SiteID LIKE estabelec.cod-estabel INITIAL ?
    FIELD SiteDescription LIKE estabelec.nome INITIAL ?
    FIELD ItemCode LIKE ITEM.it-codigo INITIAL ?  /*Campo: ped-item.it-codigo - Descrição: Código do Item do Pedido*/
    FIELD ItemDescription LIKE ITEM.desc-item INITIAL ?  /*Campo: item.desc-item - Descrição: Descrição do Item */
    FIELD ReferenceCode LIKE ITEM.cod-refer INITIAL ?  /*Campo = item.cod-refer Descrição =  Código da Referência do Item*/
    FIELD ReferenceDescription LIKE referencia.descricao INITIAL ?  /*Campo   = referencia.descricao Descrição = Descrição das referências do item*/
    FIELD UnitOfMeasureCode LIKE ITEM.un INITIAL ?  /*Campo = Item.un   Descrição = Unidade de Medida do Item*/
    FIELD UnitOfMeasureDescription LIKE tab-unidade.descricao INITIAL ?  /*Campo = tab-unidade.descricao  Descrição = Descrição da Unidade de Medida do Item*/    
    FIELD StartBalance LIKE saldo-estoq.qtidade-atu INITIAL ?  /*Campo = (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada)          Descrição = Saldo inicial do Item no Estoque*/
    FIELD SecurityStockQuantity LIKE saldo-estoq.qtidade-atu INITIAL ?  /*Campo =  QUANDO  item.tipo-est-seg = 2 ENTÃO  (item.consumo-prev / 30) * item.tempo-segur) SENÃOitem.quant-segur. Descrição = Quantidade de estoque de segurança do item*/
    FIELD AllocationQuantity LIKE saldo-estoq.qtidade-atu INITIAL ?  /*Campo = saldo-estoq.qt-alocada Descricação = Quantidade do Estoque já Alocada*/
    FIELD InventoryBalance LIKE saldo-estoq.qtidade-atu INITIAL ?  /*Campo = saldo-estoq.qtidade-atu Descrição = Quantidade Atual do Item no Estoque*/    
    FIELD EconomicStockQuantity  LIKE ITEM.lote-economi           /* Campo = lote economico */
    FIELD ReplenishmentDays LIKE ITEM.res-int-comp           /* Campo = ressuprimento de compras do item */
    FIELD ProductionDays LIKE ITEM.ressup-fabri           /* Campo = ressuprimento fabrica‡Æo do item */
    FIELD RemittanceForImproviment LIKE saldo-terc.quantidade INITIAL ? /*Campo = saldo-terc.quantidade Descri‡Æo = Remessa para Beneficiamento */
    FIELD EntranceForImproviment LIKE saldo-terc.quantidade INITIAL ? /* Campo = saldo-terc.quantidade Descri‡Æo  Entrada para Beneficiamento */
    FIELD TransferenciaOfMaterial LIKE saldo-terc.quantidade INITIAL ? /* Campo = saldo-terc.quantidade Descri‡Æo = Trasnferencial de Material */
    FIELD RemittanceConsignementContract LIKE saldo-terc.quantidade INITIAL ? /* Campo = saldo-terc.quantidade Descri‡Æo = Remessa em Consigna‡Æo */
    FIELD EntranceConsignementContract LIKE saldo-terc.quantidade INITIAL ?. /* Entrada em Consigna‡Æo */

/* Dados Gerais do sItens */
DEFINE TEMP-TABLE ttInventorySimulation NO-UNDO
     FIELD it-codigo      LIKE ITEM.it-codigo     
     FIELD cod-refer LIKE ITEM.cod-refer
     FIELD SimulationDate AS DATE INITIAL ?  /*Campo = Variável contendo  (Today da execução do programa - 1) + (Data de corte - Today)         Descrição = Data da Simulação*/     
     FIELD ProductionOrderQuantity AS decimal INITIAL ?  /*Campo = Variável contendo (ord-prod.qt-ordem - ord-prod.qt-produzida)           Descrição = Quantidade do item em produção */
     FIELD PurchaseQuantity AS decimal INITIAL ?  /*Campo = prazo-compra.quant-saldo      Descrição = Saldo do Item em Compras*/
     FIELD ReserveQuantity AS decimal INITIAL ?  /*Campo = Variável contendo (reservas.quant-orig - reservas.quant-atend)           Descrição = Quantidade do item em reservas */
     FIELD SalesOrderQuantity AS decimal INITIAL ?  /*Campo = variável contendo (ped-ent.qt-pedida - ped-ent.qt-atendida)           Descrição = Quantidade do item que se encontra em pedidos */
     FIELD AvailableQuantity AS decimal INITIAL ?.  /*Campo = Variável contendo o Saldo da Produção + Saldo de Compras - Saldo dos Pedidos - Saldo das Reservas                            Descrição = Saldo Disponível do Item*/

/* Ordens de Produçãos dos Itens */
DEFINE TEMP-TABLE ttManufacturingOrderSimul NO-UNDO
     FIELD it-codigo      LIKE ITEM.it-codigo                          /* C¢digo do Item */
     FIELD cod-refer LIKE ITEM.cod-refer
     FIELD ProductionOrderEndDate AS DATE INITIAL ?  /*Campo = ord-prod.dt-termino Descrição = Data de Término da Ordem de Produção*/
     FIELD ProductionOrderNumber AS integer INITIAL ?  /*Campo = ord-prod.nr-ord-produ Descrição = Número da Ordem de Produção do Item*/
     FIELD QuantityOfOrder AS decimal INITIAL ?  /*Campo = ord-prod.qt-ordem Descrição = Quantidade do Item da Ordem de Produção*/
     FIELD ProducedQuantity AS decimal INITIAL ?  /*Campo = ord-prod.qt-produzida Descrição = Quantidade já Produzida do Item */
     FIELD vStatus AS integer INITIAL ?.  /*Campo = ord-prod.estado Descrição = Estado da Ordem de Produção. Valores: 1 Não Iniciada, 2 Liberada, 3 Alocada, 4 Separada, 5 Requisitada, 6 Iniciada, 7 Finalizada, 8 Terminada*/

/* Ordens de Compra dos Itens */
DEFINE TEMP-TABLE ttPurchaseDetailsSimulation NO-UNDO
     FIELD it-codigo      LIKE ITEM.it-codigo                          /* C¢digo do Item */
     FIELD cod-refer LIKE ITEM.cod-refer
     FIELD BalanceQuantity  LIKE prazo-compra.quant-saldo      /*Campo = prazo-compra.quant-saldo Descrição = Saldo do Item da Ordem de Compra*/
     FIELD DeliveryDate  AS DATE INITIAL ?      /*Campo = prazo-compra.data-entrega Descrição = Data da Entrega da Ordem de Compra*/
     FIELD PurchaseOrderLine LIKE prazo-compra.numero-ordem  /*Campo = prazo-compra.numero-ordem Descrição = Número da Ordem de Compra do Item*/
     FIELD PurchaseOrderNumber LIKE ordem-compra.num-pedido /*Campo = ordem-compra.num-pedido Descrição = Número do Pedido da Ordem de Compra */
     FIELD DeliveryScheduleID LIKE prazo-compra.parcela       /*Campo = prazo-ordem.parcela Descrição = Parcela da Ordem */
     FIELD PurchaseQuantityItem LIKE prazo-compra.quantidade.  /*Campo = prazo-compra.quantidade Descrição = Quantidade do Item das Ordens de Compras*/

/* Pediso de Vendas dos Itens */
DEFINE TEMP-TABLE ttSalesOrder NO-UNDO
     FIELD it-codigo      LIKE ITEM.it-codigo                          /* C¢digo do Item */
     FIELD cod-refer LIKE ITEM.cod-refer
     FIELD CustomerName LIKE ped-venda.nome-abrev  /*Campo = ped-venda.nome-abrev Descrição = Nome abreviado do cliente*/
     FIELD CustomerOrder LIKE ped-venda.nr-pedcli   /*Campo = ped-venda.nr-pedcli              Descrição = Número do pedido de venda */
     FIELD DeliveryDate AS DATE INITIAL ?  /*Campo = ped-ent.dt-entrega Descrição = Data de entrega do item do pedido */
     FIELD BalanceOfOrderQuantity LIKE ped-item.qt-pedida    /*Campo = variável contendo o saldo de pedidos (ped-ent.qt-pedida - ped-ent.qt-atendida) - (ped-ent.qt-alocada - ped-ent.qt-atendida)*/
     FIELD StatusOfOrder LIKE ped-venda.cod-sit-ped. /*Campo = ped-venda.cod-sit-ped Descrição = Código de situação do pedido de venda*/

/* Reservas dos Itens */
DEFINE TEMP-TABLE ttRequirementDetailsSimul NO-UNDO
     FIELD it-codigo      LIKE ITEM.it-codigo                          /* C¢digo do Item */
     FIELD cod-refer LIKE ITEM.cod-refer
     FIELD ProcessedQuantity LIKE reservas.quant-atend  /*Campo = reservas.quant-atend Descrição = Quantidade atendida da Ordem de Produção */
     FIELD ProductionOrderNumber LIKE reservas.nr-ord-prod  /*Campo = reservas.nr-ord-produ Descrição = Número da Ordem de Produção do Item*/
     FIELD QuantityOfReserve LIKE reservas.quant-orig   /*Campo = reservas.quant-orig Descrição = Quantidade Original da Reserva*/
     FIELD ReserveDate AS DATE INITIAL ?.   /*Campo = reservas.dt-reserva Descrição = Data da Reserva*/

DEFINE INPUT PARAM TABLE FOR ttHeaderItem.
DEFINE INPUT PARAM TABLE FOR ttInventorySimulation.
DEFINE INPUT PARAM TABLE FOR ttManufacturingOrderSimul.
DEFINE INPUT PARAM TABLE FOR ttPurchaseDetailsSimulation.
DEFINE INPUT PARAM TABLE FOR ttSalesOrder.
DEFINE INPUT PARAM TABLE FOR ttRequirementDetailsSimul.

def var c-root                   as char no-undo.
DEF VAR c-campo AS CHAR NO-UNDO.
DEF VAR c-message AS CHAR NO-UNDO.

/* Main code */

assign c-root = CreateNeoGridDoc("InventorySimulation","1.01.001","")
       c-message = AddElement(c-root,"CRM").

FOR EACH ttHeaderItem
   BREAK BY ttHeaderItem.ItemCode
         BY ttHeaderItem.ReferenceCode:

    RUN pi-cria-cabecalho-item.

    RUN pi-simulacao-estoque.

END.

WriteXML().

RETURN "OK":U.

/* Procedures internas */

PROCEDURE pi-cria-cabecalho-item:

    DEF VAR c-estab      AS CHAR NO-UNDO.
    DEF VAR c-item       AS CHAR NO-UNDO.
    DEF VAR c-cod-refer  AS CHAR NO-UNDO.
    DEF VAR c-un         AS CHAR NO-UNDO.
    DEF VAR c-saldo      AS CHAR NO-UNDO.
    DEF VAR c-saldo-terc AS CHAR NO-UNDO.

    /* Codigo e descri‡Æo do estabelecimento  */
    ASSIGN c-estab = AddElement(c-root,"Site")
           c-campo = AddEleChar(c-estab,"SiteID",ttHeaderItem.SiteID).

    IF  ttHeaderItem.SiteDescription <> ""
    AND ttHeaderItem.SiteDescription <> ? THEN
        ASSIGN c-campo = AddEleChar(c-estab,"SiteDescription",ttHeaderItem.SiteDescription).

    /* Codigo e descri‡Æo do item  */
    ASSIGN c-item  = AddElement(c-root,"Item")
           c-campo = AddEleChar(c-item,"ItemCode",ttHeaderItem.ItemCode).

    IF  ttHeaderItem.ItemDescription <> ? 
    AND ttHeaderItem.ItemDescription <> "" then
        ASSIGN c-campo = AddEleChar(c-item,"ItemDescription",ttHeaderItem.ItemDescription).

    /* Referencia */
    ASSIGN c-cod-refer = AddElement(c-root,"Reference").
    if  ttHeaderItem.ReferenceCode <> ? 
    AND ttHeaderItem.ReferenceCode <> "" THEN
        ASSIGN c-campo = AddEleChar(c-cod-refer,"ReferenceCode",ttHeaderItem.ReferenceCode)
               c-campo = AddEleChar(c-cod-refer,"ReferenceDescription",ttHeaderItem.ReferenceDescription).

    /* Unidade Medida */
    ASSIGN c-un    = AddElement(c-root,"UnitOfMeasure")
           c-campo = AddEleChar(c-un,"UnitOfMeasureCode",ttHeaderItem.UnitOfMeasureCode).
    if  ttHeaderItem.UnitOfMeasureCode <> ? 
    AND ttHeaderItem.UnitOfMeasureCode <> "" THEN
        ASSIGN c-campo = AddEleChar(c-un,"UnitOfMeasureDescription",ttHeaderItem.UnitOfMeasureDescription).
    
    /* Quantidades do Item em Rela‡Æo ao Estoque */
    ASSIGN c-saldo = AddElement(c-root,"ItemInventoryBalance")
           c-campo = AddEleDeci(c-saldo,"StartBalance",ttHeaderItem.StartBalance) /* Saldo inicial */
           c-campo = AddEleDeci(c-saldo,"InventoryBalance",ttHeaderItem.InventoryBalance) /* Saldo Atual */
           c-campo = AddEleDeci(c-saldo,"AllocationQuantity",ttHeaderItem.AllocationQuantity) /* Quantidade Alocada */
           c-campo = AddEleDeci(c-saldo,"SecurityStockQuantity",ttHeaderItem.SecurityStockQuantity) /* Estoque de Seguran‡a */ 
           c-campo = AddEleDeci(c-saldo,"EconomicStockQuantity",ttHeaderItem.EconomicStockQuantity) /* Lote Econ“mico */
           c-campo = AddEleInt(c-saldo,"ReplenishmentDays",ttHeaderItem.ReplenishmentDays) /* Ressuprimento de Compras */
           c-campo = AddEleInt(c-saldo,"ProductionDays",ttHeaderItem.ProductionDays). /* Ressuprimento de Fabrica‡Æo */

    /* Dados do Saldo de Terceiros */
    if  ttHeaderItem.RemittanceForImproviment       <> 0 
    OR  ttHeaderItem.EntranceForImproviment         <> 0 
    OR  ttHeaderItem.TransferenciaOfMaterial        <> 0 
    OR  ttHeaderItem.RemittanceConsignementContract <> 0 
    OR  ttHeaderItem.EntranceConsignementContract   <> 0 then do:
   
        ASSIGN c-saldo-terc = AddElement(c-root,"BalanceInThird")
               c-campo = AddEleDeci(c-saldo-terc,"RemittanceForImproviment",ttHeaderItem.RemittanceForImproviment) /* Remessa Benef */
               c-campo = AddEleDeci(c-saldo-terc,"EntranceForImproviment",ttHeaderItem.EntranceForImproviment) /* Entrada Benef */
               c-campo = AddEleDeci(c-saldo-terc,"TransferenciaOfMaterial",ttHeaderItem.TransferenciaOfMaterial) /* Transferencia */
               c-campo = AddEleDeci(c-saldo-terc,"RemittanceConsignementContract",ttHeaderItem.RemittanceConsignementContract) /* Rem Consig */
               c-campo = AddEleDeci(c-saldo-terc,"EntranceConsignementContract",ttHeaderItem.EntranceConsignementContract). /* Ent Consig */
    end.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-simulacao-estoque:

    DEF VAR c-lista-simul   AS CHAR NO-UNDO.
    DEF VAR c-simul         AS CHAR NO-UNDO.
    DEF VAR c-lista-pedidos AS CHAR NO-UNDO.
    DEF VAR c-pedidos       AS CHAR NO-UNDO.
    DEF VAR c-lista-op      AS CHAR NO-UNDO.
    DEF VAR c-op            AS CHAR NO-UNDO.
    DEF VAR c-lista-res     AS CHAR NO-UNDO.
    DEF VAR c-res           AS CHAR NO-UNDO.
    DEF VAR c-lista-oc      AS CHAR NO-UNDO.
    DEF VAR c-oc            AS CHAR NO-UNDO.


    /* Le as informa‡äes b sicas dos itens */
    FOR EACH ttInventorySimulation
        WHERE ttInventorySimulation.it-codigo = ttHeaderItem.ItemCode
          AND ttInventorySimulation.cod-refer = ttHeaderItem.ReferenceCode:

       /* Ressuprimento de Compras */
        ASSIGN c-lista-simul = AddElement(c-root,"ListOfInventorySimulation")
               c-simul       = AddElement(c-lista-simul,"InventorySimulation")
               c-campo       = AddEleDate(c-simul,"SimulationDate",ttInventorySimulation.SimulationDate,"") /* Data Simula‡Æo */
               c-campo       = AddEleDeci(c-simul,"SalesOrderQuantity",ttInventorySimulation.SalesOrderQuantity). /* Qt Pedidos */

        IF  ttInventorySimulation.SimulationDate < TODAY THEN DO:

            /* Pedidos dos Clientes */
            IF  CAN-FIND (FIRST ttSalesOrder 
                          WHERE ttSalesOrder.it-codigo = ttInventorySimulation.it-codigo
                            AND ttSalesOrder.cod-refer = ttInventorySimulation.cod-refer
                            AND ttSalesOrder.DeliveryDate < TODAY) THEN DO:

                ASSIGN c-lista-pedidos = AddElement(c-simul,"ListOfSalesOrder").

                 /* Le os Pedidos dos Clientes */
                 FOR EACH ttSalesOrder 
                     WHERE ttSalesOrder.it-codigo    = ttInventorySimulation.it-codigo
                       AND ttSalesOrder.cod-refer    = ttInventorySimulation.cod-refer
                       AND ttSalesOrder.DeliveryDate < TODAY
                     BREAK BY ttSalesOrder.DeliveryDate: 

                     ASSIGN c-pedidos = AddElement(c-lista-pedidos,"SalesOrder")
                            c-campo   = AddEleDate(c-pedidos,"DeliveryDate",ttSalesOrder.DeliveryDate,"") /* Dt entrega item pedido */
                            c-campo   = AddEleChar(c-pedidos,"CustomerOrder",ttSalesOrder.CustomerOrder) /* Nro pedido de venda */
                            c-campo   = AddEleChar(c-pedidos,"CustomerName",ttSalesOrder.CustomerName) /* Nome do cliente do pedido */
                            c-campo   = AddEleInt(c-pedidos,"StatusOfOrder",ttSalesOrder.StatusOfOrder) /* Situa‡Æo do pedido */
                            c-campo   = AddEleDeci(c-pedidos,"BalanceOfOrderQuantity",ttSalesOrder.BalanceOfOrderQuantity). /* Saldo pedido */
                 END.
            END.

            /* Quantidade em ordens de produ‡Æo */
            ASSIGN c-campo = AddEleDeci(c-simul,"ProductionOrderQuantity",ttInventorySimulation.ProductionOrderQuantity).

            /* Ordens de Produ‡Æo do item */
            IF  CAN-FIND (FIRST ttManufacturingOrderSimul 
                          WHERE ttManufacturingOrderSimul.it-codigo              = ttInventorySimulation.it-codigo
                            AND ttManufacturingOrderSimul.cod-refer              = ttInventorySimulation.cod-refer
                            AND ttManufacturingOrderSimul.ProductionOrderEndDate < TODAY) THEN DO:

                ASSIGN c-lista-op = AddElement(c-simul,"ListOfProductionOrders").

                 FOR EACH ttManufacturingOrderSimul 
                     WHERE ttManufacturingOrderSimul.it-codigo              = ttInventorySimulation.it-codigo
                       AND ttManufacturingOrderSimul.cod-refer              = ttInventorySimulation.cod-refer
                       AND ttManufacturingOrderSimul.ProductionOrderEndDate < TODAY
                     BREAK BY ttManufacturingOrderSimul.ProductionOrderNumber:

                     ASSIGN c-op    = AddElement(c-lista-op,"ProductionOrders")
                            c-campo = AddEleDate(c-op,"ProductionOrderEndDate",ttManufacturingOrderSimul.ProductionOrderEndDate,"") /* Dt termino op */  
                            c-campo = AddEleInt(c-op,"ProductionOrderNumber",ttManufacturingOrderSimul.ProductionOrderNumber) /* Nr OP */  
                            c-campo = AddEleDeci(c-op,"QuantityOfOrder",ttManufacturingOrderSimul.QuantityOfOrder) /* Qtde OP */  
                            c-campo = AddEleDeci(c-op,"ProducedQuantity",ttManufacturingOrderSimul.ProducedQuantity) /* Qtde produzida */ 
                            c-campo = AddEleInt(c-op,"Status",ttManufacturingOrderSimul.vStatus). /* Estado OP */
                 END.
            END.

            /* Quantidade do item em reservas  */
            ASSIGN c-campo = AddEleDeci(c-simul,"ReserveQuantity",ttInventorySimulation.ReserveQuantity).
            
            /* Resevas dos Itens */
            IF  CAN-FIND (FIRST ttRequirementDetailsSimul 
                          WHERE ttRequirementDetailsSimul.it-codigo   = ttInventorySimulation.it-codigo
                            AND ttRequirementDetailsSimul.cod-refer   = ttInventorySimulation.cod-refer
                            AND ttRequirementDetailsSimul.ReserveDate < TODAY) THEN DO:

                ASSIGN c-lista-res = AddElement(c-simul,"ListOfReserves").

                FOR EACH ttRequirementDetailsSimul 
                    WHERE ttRequirementDetailsSimul.it-codigo   = ttInventorySimulation.it-codigo
                      AND ttRequirementDetailsSimul.cod-refer   = ttInventorySimulation.cod-refer
                      AND ttRequirementDetailsSimul.ReserveDate < TODAY
                    BREAK BY ttRequirementDetailsSimul.ProductionOrderNumber:

                    ASSIGN c-res   = AddElement(c-lista-res,"Reserves")
                           c-campo = AddEleDate(c-res,"ReserveDate",ttRequirementDetailsSimul.ReserveDate,"") /* Data Reserva */  
                           c-campo = AddEleInt(c-res,"ProductionOrderNumber",ttRequirementDetailsSimul.ProductionOrderNumber) /* Nr OP */  
                           c-campo = AddEleDeci(c-res,"QuantityOfReserve",ttRequirementDetailsSimul.QuantityOfReserve) /* Qtde Reserva */  
                           c-campo = AddEleDeci(c-res,"ProcessedQuantity",ttRequirementDetailsSimul.ProcessedQuantity). /* Qtde utilizada */
                END.
            END.

            /*  Saldo do Item em Compras */
            ASSIGN c-campo = AddEleDeci(c-simul,"PurchaseQuantity",ttInventorySimulation.PurchaseQuantity).

            /* Ordens de Compras dos Itens */
            IF  CAN-FIND (FIRST ttPurchaseDetailsSimulation 
                          WHERE ttPurchaseDetailsSimulation.it-codigo = ttInventorySimulation.it-codigo
                            AND ttPurchaseDetailsSimulation.cod-refer = ttInventorySimulation.cod-refer
                            AND ttPurchaseDetailsSimulation.DeliveryDate < TODAY) THEN DO:

                ASSIGN c-lista-oc = AddElement(c-simul,"ListOfPurchaseOrders").
                
                FOR EACH ttPurchaseDetailsSimulation 
                    WHERE ttPurchaseDetailsSimulation.it-codigo    = ttInventorySimulation.it-codigo
                      AND ttPurchaseDetailsSimulation.cod-refer    = ttInventorySimulation.cod-refer
                      AND ttPurchaseDetailsSimulation.DeliveryDate < TODAY
                    BREAK BY ttPurchaseDetailsSimulation.PurchaseOrderLine:

                    ASSIGN c-oc    = AddElement(c-lista-oc,"PurchaseOrders")
                           c-campo = AddEleDate(c-oc,"DeliveryDate",ttPurchaseDetailsSimulation.DeliveryDate,"") /* Dt entrega OC */  
                           c-campo = AddEleInt(c-oc,"PurchaseOrderLine",ttPurchaseDetailsSimulation.PurchaseOrderLine) /* Nr OC Item */  
                           c-campo = AddEleInt(c-oc,"DeliveryScheduleID",ttPurchaseDetailsSimulation.DeliveryScheduleID) /* Parcela OC */  
                           c-campo = AddEleInt(c-oc,"PurchaseOrderNumber",ttPurchaseDetailsSimulation.PurchaseOrderNumber) /* Nro pedido */
                           c-campo = AddEleDeci(c-oc,"PurchaseQuantityItem",ttPurchaseDetailsSimulation.PurchaseQuantityItem) /* Qt Item */
                           c-campo = AddEleDeci(c-oc,"BalanceQuantity",ttPurchaseDetailsSimulation.BalanceQuantity). /* Saldo Item na OC */
                 END.
            END.
        END.
        ELSE DO:
            /* Pedidos dos Clientes */
            IF  CAN-FIND (FIRST ttSalesOrder 
                          WHERE ttSalesOrder.it-codigo    = ttInventorySimulation.it-codigo
                            AND ttSalesOrder.cod-refer    = ttInventorySimulation.cod-refer
                            AND ttSalesOrder.DeliveryDate = ttInventorySimulation.SimulationDate) THEN DO:

                ASSIGN c-lista-pedidos = AddElement(c-simul,"ListOfSalesOrder").

                 /* Le os Pedidos dos Clientes */
                 FOR EACH ttSalesOrder 
                     WHERE ttSalesOrder.it-codigo    = ttInventorySimulation.it-codigo
                       AND ttSalesOrder.cod-refer    = ttInventorySimulation.cod-refer
                       AND ttSalesOrder.DeliveryDate = ttInventorySimulation.SimulationDate
                     BREAK BY ttSalesOrder.DeliveryDate: 

                     ASSIGN c-pedidos = AddElement(c-lista-pedidos,"SalesOrder")
                            c-campo   = AddEleDate(c-pedidos,"DeliveryDate",ttSalesOrder.DeliveryDate,"") /* Dt entrega item pedido */
                            c-campo   = AddEleChar(c-pedidos,"CustomerOrder",ttSalesOrder.CustomerOrder) /* Nro pedido de venda */
                            c-campo   = AddEleChar(c-pedidos,"CustomerName",ttSalesOrder.CustomerName) /* Nome do cliente do pedido */
                            c-campo   = AddEleInt(c-pedidos,"StatusOfOrder",ttSalesOrder.StatusOfOrder) /* Situa‡Æo do pedido */
                            c-campo   = AddEleDeci(c-pedidos,"BalanceOfOrderQuantity",ttSalesOrder.BalanceOfOrderQuantity). /* Saldo pedido */
                 END.
            END.

            /* Quantidade em ordens de produ‡Æo */
            ASSIGN c-campo = AddEleDeci(c-simul,"ProductionOrderQuantity",ttInventorySimulation.ProductionOrderQuantity).

            /* Ordens de Produ‡Æo do item */
            IF  CAN-FIND (FIRST ttManufacturingOrderSimul 
                          WHERE ttManufacturingOrderSimul.it-codigo              = ttInventorySimulation.it-codigo
                            AND ttManufacturingOrderSimul.cod-refer              = ttInventorySimulation.cod-refer
                            AND ttManufacturingOrderSimul.ProductionOrderEndDate = ttInventorySimulation.SimulationDate) THEN DO:

                ASSIGN c-lista-op = AddElement(c-simul,"ListOfProductionOrders").

                 FOR EACH ttManufacturingOrderSimul 
                     WHERE ttManufacturingOrderSimul.it-codigo              = ttInventorySimulation.it-codigo
                       AND ttManufacturingOrderSimul.cod-refer              = ttInventorySimulation.cod-refer
                       AND ttManufacturingOrderSimul.ProductionOrderEndDate = ttInventorySimulation.SimulationDate
                     BREAK BY ttManufacturingOrderSimul.ProductionOrderNumber:

                     ASSIGN c-op    = AddElement(c-lista-op,"ProductionOrders")
                            c-campo = AddEleDate(c-op,"ProductionOrderEndDate",ttManufacturingOrderSimul.ProductionOrderEndDate,"") /* Dt termino op */  
                            c-campo = AddEleInt(c-op,"ProductionOrderNumber",ttManufacturingOrderSimul.ProductionOrderNumber) /* Nr OP */  
                            c-campo = AddEleDeci(c-op,"QuantityOfOrder",ttManufacturingOrderSimul.QuantityOfOrder) /* Qtde OP */  
                            c-campo = AddEleDeci(c-op,"ProducedQuantity",ttManufacturingOrderSimul.ProducedQuantity) /* Qtde produzida */ 
                            c-campo = AddEleInt(c-op,"Status",ttManufacturingOrderSimul.vStatus). /* Estado OP */
                 END.
            END.

            /* Quantidade do item em reservas  */
            ASSIGN c-campo = AddEleDeci(c-simul,"ReserveQuantity",ttInventorySimulation.ReserveQuantity).
            
            /* Resevas dos Itens */
            IF  CAN-FIND (FIRST ttRequirementDetailsSimul 
                          WHERE ttRequirementDetailsSimul.it-codigo   = ttInventorySimulation.it-codigo
                            AND ttRequirementDetailsSimul.cod-refer   = ttInventorySimulation.cod-refer
                            AND ttRequirementDetailsSimul.ReserveDate = ttInventorySimulation.SimulationDate) THEN DO:

                ASSIGN c-lista-res = AddElement(c-simul,"ListOfReserves").

                FOR EACH ttRequirementDetailsSimul 
                    WHERE ttRequirementDetailsSimul.it-codigo   = ttInventorySimulation.it-codigo
                      AND ttRequirementDetailsSimul.cod-refer   = ttInventorySimulation.cod-refer
                      AND ttRequirementDetailsSimul.ReserveDate = ttInventorySimulation.SimulationDate
                    BREAK BY ttRequirementDetailsSimul.ProductionOrderNumber:

                    ASSIGN c-res   = AddElement(c-lista-res,"Reserves")
                           c-campo = AddEleDate(c-res,"ReserveDate",ttRequirementDetailsSimul.ReserveDate,"") /* Data Reserva */  
                           c-campo = AddEleInt(c-res,"ProductionOrderNumber",ttRequirementDetailsSimul.ProductionOrderNumber) /* Nr OP */  
                           c-campo = AddEleDeci(c-res,"QuantityOfReserve",ttRequirementDetailsSimul.QuantityOfReserve) /* Qtde Reserva */  
                           c-campo = AddEleDeci(c-res,"ProcessedQuantity",ttRequirementDetailsSimul.ProcessedQuantity). /* Qtde utilizada */
                END.
            END.

            /*  Saldo do Item em Compras */
            ASSIGN c-campo = AddEleDeci(c-simul,"PurchaseQuantity",ttInventorySimulation.PurchaseQuantity).

            /* Ordens de Compras dos Itens */
            IF  CAN-FIND (FIRST ttPurchaseDetailsSimulation 
                          WHERE ttPurchaseDetailsSimulation.it-codigo    = ttInventorySimulation.it-codigo
                            AND ttPurchaseDetailsSimulation.cod-refer    = ttInventorySimulation.cod-refer
                            AND ttPurchaseDetailsSimulation.DeliveryDate = ttInventorySimulation.SimulationDate) THEN DO:

                ASSIGN c-lista-oc = AddElement(c-simul,"ListOfPurchaseOrders").
                
                FOR EACH ttPurchaseDetailsSimulation 
                    WHERE ttPurchaseDetailsSimulation.it-codigo    = ttInventorySimulation.it-codigo
                      AND ttPurchaseDetailsSimulation.cod-refer    = ttInventorySimulation.cod-refer
                      AND ttPurchaseDetailsSimulation.DeliveryDate = ttInventorySimulation.SimulationDate
                    BREAK BY ttPurchaseDetailsSimulation.PurchaseOrderLine:

                    ASSIGN c-oc    = AddElement(c-lista-oc,"PurchaseOrders")
                           c-campo = AddEleDate(c-oc,"DeliveryDate",ttPurchaseDetailsSimulation.DeliveryDate,"") /* Dt entrega OC */  
                           c-campo = AddEleInt(c-oc,"PurchaseOrderLine",ttPurchaseDetailsSimulation.PurchaseOrderLine) /* Nr OC Item */  
                           c-campo = AddEleInt(c-oc,"DeliveryScheduleID",ttPurchaseDetailsSimulation.DeliveryScheduleID) /* Parcela OC */  
                           c-campo = AddEleInt(c-oc,"PurchaseOrderNumber",ttPurchaseDetailsSimulation.PurchaseOrderNumber) /* Nro pedido */
                           c-campo = AddEleDeci(c-oc,"PurchaseQuantityItem",ttPurchaseDetailsSimulation.PurchaseQuantityItem) /* Qt Item */
                           c-campo = AddEleDeci(c-oc,"BalanceQuantity",ttPurchaseDetailsSimulation.BalanceQuantity). /* Saldo Item na OC */
                 END.
            END.
        END. /* else do */

        /* Saldo Dispon¡vel do Item */
        ASSIGN c-campo = AddEleDeci(c-simul,"AvailableQuantity",ttInventorySimulation.AvailableQuantity).

    END. /* for each ttInventorySimul */

    RETURN "OK":U.

END PROCEDURE.

/* Fim */
