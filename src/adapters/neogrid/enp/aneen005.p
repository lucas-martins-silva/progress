/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEEN005 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneen005 MAN}
&ENDIF

/******************************************************************************
**  Programa: aneen005.p
**  Funcao  : Sender do item
**  Data    : 09/2002
**  Autor   : Sirlei Fernandes
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */


DEF INPUT PARAM p-rowid         AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel   LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente  LIKE emitente.cod-emitente NO-UNDO.
DEF INPUT PARAM c-acao          AS CHAR                    NO-UNDO.


DEF VAR c-root                  AS CHAR                    NO-UNDO.
DEF VAR c-message               AS CHAR                    NO-UNDO.
DEF VAR c-campo                 AS CHAR                    NO-UNDO.
DEF VAR c-CatalogItemNG         AS CHAR                    NO-UNDO.
DEF VAR c-CatalogItem           AS CHAR                    NO-UNDO.
DEF VAR c-CatalogItemCollection AS CHAR                    NO-UNDO.
DEF VAR c-State-Value           AS CHAR INITIAL "ACTIVE"   NO-UNDO.
DEF VAR c-FromUOM               AS CHAR                    NO-UNDO.
DEF VAR c-ToUOM                 AS CHAR                    NO-UNDO.
DEF VAR c-FromRole              AS CHAR                    NO-UNDO.
DEF VAR c-ToRole                AS CHAR                    NO-UNDO.
DEF VAR c-desc-familia          LIKE familia.descricao     NO-UNDO.

{adapters/neogrid/include/anein004.i} /*sender*/

IF  p-rowid <> ? THEN DO:
    FIND ITEM WHERE ROWID(ITEM) = p-rowid NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN DO:
       RUN pi-cabecalho-msg.    
       RUN pi-corpo-msg.
       RUN pi-rodape-msg.
       WRITExml().
    END.
END.

PROCEDURE pi-cabecalho-msg:

    DEF VAR c-SupplierInformation AS CHAR NO-UNDO.

    ASSIGN c-root = CreateNeoGridDoc("CatalogueItemImportNG", "1.01.001", "not used")
             c-message                   = AddElement(c-root,"Message")
               c-CatalogItemNG           = AddElement(c-message,"CatalogueItemImportNG")
                 c-catalogitemcollection = AddElement(c-CatalogItemNG,"CatalogueItemCollection")
                 c-FromRole              = AddElement(c-CatalogItemNG,"FromRole")
                 c-ToRole                = AddElement(c-CatalogItemNG,"ToRole").

END PROCEDURE.

PROCEDURE pi-corpo-msg:
    DEF VAR d-registerdate AS DATE          NO-UNDO.
    DEF VAR PRODUTO        AS INT INITIAL 1 NO-UNDO.
    DEF VAR NORMAL         AS INT INITIAL 0 NO-UNDO.
    DEF VAR DEBITO-DIRETO  AS INT INITIAL 4 NO-UNDO.

    ASSIGN c-CatalogItem = AddElement(c-CatalogItemCollection,"CatalogueItem")
             c-campo     = AddEleChar(c-CatalogItem, "Type","1")
             c-campo     = AddEleChar(c-CatalogItem, "ItemIdentifier", item.it-codigo)
             c-campo     = AddEleDate(c-CatalogItem, "RegisterDate", item.data-implant, "00:00:00")
             c-campo     = AddEleChar(c-CatalogItem, "Reference", item.cod-refer)
             c-campo     = AddEleChar(c-CatalogItem, "SubType", IF item.tipo-contr < 4 THEN "0" ELSE "4")
             c-campo     = AddEleChar(c-CatalogItem, "OldCode", item.it-codigo)
             c-campo     = AddEleChar(c-CatalogItem, "LegacyUnitOfMeasure", item.un)
             c-campo     = AddEleChar(c-CatalogItem, "MaterialFamily", item.fm-codigo)
             c-campo     = AddEleChar(c-CatalogItem, "CommercialFamily", item.fm-cod-com)
             c-campo     = AddEleDeci(c-CatalogItem, "AliquotaIPI", item.aliquota-ipi).

    FIND familia 
        WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.

    IF AVAIL familia THEN
        ASSIGN c-desc-familia = familia.descricao.
    ELSE
        ASSIGN c-desc-familia = "".

    ASSIGN c-campo     = AddEleChar(c-CatalogItem, "MaterialFamilyName", c-desc-familia).
    RUN BuildCatalogueItemState.
    RUN BuildCatalogueItemLocale.
    RUN BuildTechnicalView.
    RUN BuildCommerceView.
    RUN BuildInventoryView.
    RUN BuildFinanceView.

END PROCEDURE.

PROCEDURE BuildCatalogueItemState:
    DEF VAR c-State       AS CHAR NO-UNDO.
    DEF VAR d-InitialDate AS DATE NO-UNDO.
    DEF VAR d-FinalDate   AS DATE NO-UNDO.

    if (item.cod-obsoleto > 3) then do:
        assign c-State-Value = "INACTIVE".
    end.

    ASSIGN c-state   = AddElement(c-CatalogItem, "CatalogueItemState")
             c-campo = AddEleChar(c-State, "State", c-state-value)
             c-campo = AddEleDate(c-State, "InitialDate", item.data-implant,"00:00:00")
             c-campo = AddEleDate(c-State, "FinalDate", (item.data-implant + (10 * 365)),"00:00:00").

END.

PROCEDURE BuildCatalogueItemLocale:
    DEF VAR c-Locale AS CHAR.

    ASSIGN c-Locale  = AddElement(c-CatalogItem, "CatalogueItemLocale")
             c-campo = AddEleChar(c-Locale, "ItemName", item.desc-item)
             c-campo = AddEleChar(c-Locale, "ItemDescription", item.narrativa)
             c-campo = AddEleInt(c-Locale, "LocaleID", 3). /* portugues brasil */

END.

PROCEDURE BuildTechnicalView:
    DEF VAR c-technical AS CHAR.
    DEF VAR c-size AS CHAR.
    DEF VAR c-height AS CHAR.
    DEF VAR c-volume AS CHAR.
    DEF VAR c-weight AS CHAR.
    DEF VAR c-weightnet AS CHAR.
    DEF VAR c-length AS CHAR.
    DEF VAR c-depth AS CHAR.
    DEF VAR c-um-dim AS CHAR.
    DEF VAR c-um-peso AS CHAR.

    ASSIGN c-um-dim  = "CM"
           c-um-peso = "KG".
    FIND FIRST item-fornec OF item NO-LOCK NO-ERROR.
    
    ASSIGN c-technical   = AddElement(c-CatalogItem, "TechnicalView")
             c-size      = AddElement(c-technical, "Size")
               c-campo   = AddEleDeci(c-size, "Value", item.comprim)
               c-campo   = AddEleChar(c-size, "LegacyUnitOfMeasure", c-um-dim)

             c-height    = AddElement(c-technical, "Height")
               c-campo   = AddEleDeci(c-height, "Value", item.altura)
               c-campo   = AddEleChar(c-height, "LegacyUnitOfMeasure", c-um-dim)

             c-volume    = AddElement(c-technical, "Volume")
               c-campo   = AddEleDeci(c-volume, "Value", item.volume)
               c-campo   = AddEleChar(c-volume, "LegacyUnitOfMeasure", c-um-dim)

             c-weight    = AddElement(c-technical, "Weight")
               c-campo   = AddEleDeci(c-weight, "Value", item.peso-bruto)
               c-campo   = AddEleChar(c-weight, "LegacyUnitOfMeasure", c-um-peso)

             c-weightnet = AddElement(c-technical, "WeightNet")
               c-campo   = AddEleDeci(c-weightnet, "Value", item.peso-liquido)
               c-campo   = AddEleChar(c-weightnet, "LegacyUnitOfMeasure", c-um-peso)

             c-length    = AddElement(c-technical, "Length")
               c-campo   = AddEleDeci(c-length, "Value", item.largura)
               c-campo   = AddEleChar(c-length, "LegacyUnitOfMeasure", c-um-dim)

             c-campo     = AddEleDate(c-technical, "RegisterDate", item.data-implant ,"00:00:00")
             c-campo     = AddEleChar(c-technical, "TechnicalDescription", item.desc-item)
             c-campo     = AddEleInt(c-technical, "ManufacturerCode",  IF AVAIL ITEM-fornec  THEN item-fornec.cod-emitente ELSE 0 )
      
             c-depth     = AddElement(c-technical, "Depth")
               c-campo   = AddEleDeci(c-depth, "Value", item.comprim)
               c-campo   = AddEleChar(c-depth, "LegacyUnitOfMeasure", c-um-dim).

END.

PROCEDURE BuildCommerceView:
    DEF VAR c-commerce AS CHAR NO-UNDO.
    DEF VAR c-locale   AS CHAR NO-UNDO.
    DEF VAR c-state    AS CHAR NO-UNDO.

    ASSIGN c-commerce  = AddElement(c-CatalogItem, "CommerceView")
             c-campo   = AddEleInt(c-commerce,  "Type", 1)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeProcessSales", item.ressup-fabri)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeProcessPurchase", item.res-int-comp + item.res-for-comp)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeManufacture", item.ressup-fabri)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeShipping", 0)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeTransport", 0)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeReceive", 0)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeQualityControl", item.res-cq-comp)
             c-campo   = AddEleDeci(c-commerce, "MinimumOrderValue", item.lote-multipl)
             c-campo   = AddEleDeci(c-commerce, "MaximumOrderValue", 0.0)
             c-campo   = AddEleDeci(c-commerce, "MultipleLot", item.lote-multipl)
             c-campo   = AddEleDeci(c-commerce, "EconomicLot", item.lote-econom)
             c-campo   = AddEleChar(c-commerce, "PartialDelivery", IF FALSE THEN "TRUE" ELSE "FALSE")
             c-campo   = AddEleChar(c-commerce, "CancelOrder", IF FALSE THEN "TRUE" ELSE "FALSE")
             c-campo   = AddEleDeci(c-commerce, "ScrapRate", item.fator-refugo)
             c-campo   = AddEleDeci(c-commerce, "ShrinkageQuantity", item.quant-perda)
             c-campo   = AddEleInt(c-commerce,  "PurchaseLeadTime", item.res-int-comp)
             c-campo   = AddEleInt(c-commerce,  "SalesLeadTime", item.ressup-fabri)
             c-campo   = AddEleDate(c-commerce, "RegisterDate", item.data-implant,"00:00:00")
             c-campo   = AddEleDeci(c-commerce, "BalanceOrderCancel", 0.0)
             c-campo   = AddEleInt(c-commerce,  "LeadTimeGenerate", 0)
             c-campo   = AddEleInt(c-commerce,  "CriticalClassification", item.criticidade)
             c-campo   = AddEleChar(c-commerce, "FractionalQuantity", IF item.fraciona THEN "TRUE" ELSE "FALSE")
             c-campo   = Addelechar(c-commerce, "Buyer", item.cod-comprado)
             c-campo   = AddEleChar(c-commerce, "FiscalSortKey",ITEM.class-fiscal)  

             c-locale  = AddElement(c-commerce, "CommerceViewLocale")
               c-campo = AddEleChar(c-locale, "Description", item.desc-item)

             c-state   = AddElement(c-commerce, "CommerceViewState")
               c-campo = AddEleChar(c-state, "State", c-state-value)
               c-campo = AddEleDate(c-state, "InitialDate", item.data-implant,"00:00:00")
               c-campo = AddEleDate(c-state, "FinalDate", (item.data-implant + (10 * 365)),"00:00:00").

END.

PROCEDURE BuildInventoryView:
    DEF VAR c-inventory AS CHAR.
    DEF VAR c-reorder AS CHAR.
    DEF VAR c-sftystckmin AS CHAR.
    DEF VAR c-sftystckmax AS CHAR.
    DEF VAR c-stckmin AS CHAR.
    DEF VAR c-stckmax AS CHAR.
    DEF VAR c-state AS CHAR.

    ASSIGN c-inventory = AddElement(c-catalogitem, "InventoryView")
             c-campo   = AddEleChar(c-inventory, "StockCondition", "")
             c-campo   = AddEleint(c-inventory, "ReorderPoint", ITEM.ressup-fabr)
             c-campo   = AddEleChar(c-inventory, "Warehouse", item.deposito-pad)
             c-campo   = AddEleInt(c-inventory, "ForecastHorizon", 0)
             c-campo   = AddEleInt(c-inventory, "ForecastPeriod", 0)
             c-campo   = AddEleDeci(c-inventory, "SafetyStock", item.quant-segur)
             c-campo   = AddEleInt(c-inventory, "SafetyStockUnit", item.tipo-est-seg)
             c-campo   = AddEleDeci(c-inventory, "MinimumStock", 0.0)
             c-campo   = AddEleDeci(c-inventory, "MaximumStock", item.cap-est-fabr)
             c-campo   = AddEleInt(c-inventory, "StockUnit", 0)
             c-campo   = AddEleDeci(c-inventory, "SafetyStockMinimumTolerance", 1.0)
             c-campo   = AddEleDeci(c-inventory, "SafetyStockMaximumTolerance", 1.0)
             c-campo   = AddEleDeci(c-inventory, "StockMinimumTolerance", 1.0)
             c-campo   = AddEleDeci(c-inventory, "StockMaximumTolerance", 1.0)
             c-campo   = AddEleInt(c-inventory, "InventoryGroup",ITEM.ge-codigo)

           c-state     = AddElement(c-inventory, "InventoryViewState")
             c-campo   = AddEleChar(c-state, "State", c-state-value)
             c-campo   = AddEleDate(c-state, "InitialDate", item.data-implant,"00:00:00")
             c-campo   = AddEleDate(c-state, "FinalDate", (item.data-implant + (10 * 365)),"00:00:00").

END.

PROCEDURE BuildFinanceView:

    DEF VAR c-finance AS CHAR.
    DEF VAR c-state AS CHAR.
    
    ASSIGN c-finance = AddElement(c-catalogitem, "FinanceView")
             c-campo   = AddEleDeci(c-finance, "IPI", item.aliquota-ipi)
             c-campo   = AddEleChar(c-finance, "IPIIncluded", "FALSE" /*IF ITEM.cd-trib-ipi = 1 THEN "TRUE" ELSE "FALSE"*/)
           c-state     = AddElement(c-finance, "FinanceViewState")
             c-campo   = AddEleChar(c-state, "State", c-state-value)
             c-campo   = AddEleDate(c-state, "InitialDate", item.data-implant,"00:00:00")
             c-campo   = AddEleDate(c-state, "FinalDate", (item.data-implant + (10 * 365)),"00:00:00").

END.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo   = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo   = AddEleChar(c-ToRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.


