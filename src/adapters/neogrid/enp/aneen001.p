/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEEN001 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneen001 MAN}
&ENDIF

/********************************************************************************
** Programa : aneen001.p
** Fun‡Æo   : Sender do item
** Data     : 02/05/2001
** Autor    : Anderson Elton Kruger
********************************************************************************/

run utp/ut-neog.p. /* Valida se Neogrid eCS est  implantado */
if return-value = "NOK" then return.

{adapters/neogrid/include/anein004.i}


/********************************************************************************************
** Temp-table tt-item : Temp-table que vai possuir as informa‡äes 
** referentes ao cadastro de Itens.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen001.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen001.i} 

/********************************************************************************************
** Temp-table tt-to-role : Temp-table que vai possuir as informa‡äes 
** referentes ao destinat rio da mensagem.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen002.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen002.i} 

/********************************************************************************************
** Temp-table tt-from-role : Temp-table que vai possuir as informa‡äes 
** referentes a origem da mensagem.
** Nome do Include com os Parƒmetros: adapters/neogrid/enp/aneen003.i
*********************************************************************************************/
{adapters/neogrid/enp/aneen003.i} 


DEF INPUT PARAM TABLE FOR tt-item.
DEF INPUT PARAM TABLE FOR tt-from-role.
DEF INPUT PARAM TABLE FOR tt-to-role.

DEF VAR c-root                  AS CHAR. 
DEF VAR c-message               AS CHAR.
DEF VAR c-campo                 AS CHAR.
DEF VAR c-catalogitemng         AS CHAR.
DEF VAR c-catalogitem           AS CHAR.
DEF VAR c-catalogitemcollection AS CHAR.
DEF VAR c-state-value           AS CHAR INITIAL "ACTIVE".

RUN senditem.

/*
**
** BEGIN PROCEDURE DEFINITION
**
*/

PROCEDURE senditem:
    RUN BuildItemHeader.
    FOR EACH tt-item:
        RUN BuildItem.
    END.
    RUN BuildFromRole.
    RUN BuildToRole.
    WriteXML().
END.


PROCEDURE BuildItemHeader:
    DEF VAR c-supplierinformation AS CHAR.

    ASSIGN
    c-root = CreateNeoGridDoc("CatalogueItemImportNG", "1.01.001", "not used")
      c-message = AddElement(c-root,"Message")
        c-catalogitemng = AddElement(c-message,"CatalogueItemNG")
          c-catalogitemcollection = AddElement(c-catalogitemng,"CatalogueItemCollection").
END.


PROCEDURE BuildItem:

    DEF VAR d-registerdate AS DATE.
    DEF VAR PRODUTO AS INT INITIAL 1.
    DEF VAR NORMAL AS INT INITIAL 0.
    DEF VAR DEBITO-DIRETO AS INT INITIAL 4.

    ASSIGN
    c-catalogitem = AddElement(c-catalogitemcollection,"CatalogueItem")
      c-campo = AddEleInt(c-catalogitem, "Type", PRODUTO)
      c-campo = AddEleChar(c-catalogitem, "ItemIdentifier", tt-item.it-codigo)
      c-campo = AddEleDate(c-catalogitem, "RegisterDate", tt-item.data-implant, "00:00:00")
      c-campo = AddEleChar(c-catalogitem, "Reference", tt-item.reference)
      c-campo = AddEleInt(c-catalogitem, "SubType", IF tt-item.tipo-contr < 4 THEN NORMAL ELSE DEBITO-DIRETO)
      c-campo = AddEleChar(c-catalogitem, "OldCode", tt-item.it-codigo)
      c-campo = AddEleChar(c-catalogitem, "LegacyUnitOfMeasure", tt-item.un). 
    RUN BuildCatalogueItemState.
    RUN BuildCatalogueItemLocale.
    RUN BuildTechnicalView.
    RUN BuildCommerceView.
    RUN BuildInventoryView.

END.


PROCEDURE BuildCatalogueItemState:
    DEF VAR c-state AS CHAR.
    DEF VAR d-initialdate AS DATE.
    DEF VAR d-finaldate AS DATE.

    if (tt-item.cod-obsoleto > 3) then do:
        assign c-state-value = "INACTIVE".
    end.

    ASSIGN
    c-state = AddElement(c-catalogitem, "CatalogueItemState")
      c-campo = AddEleChar(c-state, "State", c-state-value)
      c-campo = AddEleDate(c-state, "InitialDate", tt-item.data-implant,"00:00:00")
      c-campo = AddEleDate(c-state, "FinalDate", (tt-item.data-implant + (2 * 365)),"00:00:00").

END.

PROCEDURE BuildCatalogueItemLocale:
    DEF VAR c-locale AS CHAR.

    ASSIGN
    c-locale = AddElement(c-catalogitem, "CatalogueItemLocale")
      c-campo = AddEleChar(c-locale, "ItemName", tt-item.desc-item)
      c-campo = AddEleChar(c-locale, "ItemDescription", tt-item.narrativa)
      c-campo = AddEleInt(c-locale, "LocaleID", 3). /* portugues brasil */

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

    ASSIGN c-um-dim = "CM"
           c-um-peso = "KG".
    
    ASSIGN
    c-technical = AddElement(c-catalogitem, "TechnicalView")

      c-size = AddElement(c-technical, "Size")
      c-campo = AddEleDeci(c-size, "Value", tt-item.comprim)
      c-campo = AddEleChar(c-size, "LegacyUnitOfMeasure", c-um-dim)

      c-height = AddElement(c-technical, "Height")
      c-campo = AddEleDeci(c-height, "Value", tt-item.altura)
      c-campo = AddEleChar(c-height, "LegacyUnitOfMeasure", c-um-dim)

      c-volume = AddElement(c-technical, "Volume")
      c-campo = AddEleDeci(c-volume, "Value", tt-item.volume)
      c-campo = AddEleChar(c-volume, "LegacyUnitOfMeasure", c-um-dim)

      c-weight = AddElement(c-technical, "Weight")
      c-campo = AddEleDeci(c-weight, "Value", tt-item.peso-bruto)
      c-campo = AddEleChar(c-weight, "LegacyUnitOfMeasure", c-um-peso)

      c-weightnet = AddElement(c-technical, "WeightNet")
      c-campo = AddEleDeci(c-weightnet, "Value", tt-item.peso-liquido)
      c-campo = AddEleChar(c-weightnet, "LegacyUnitOfMeasure", c-um-peso)

      c-length = AddElement(c-technical, "Length")
      c-campo = AddEleDeci(c-length, "Value", tt-item.largura)
      c-campo = AddEleChar(c-length, "LegacyUnitOfMeasure", c-um-dim)

      c-campo = AddEleDate(c-technical, "RegisterDate", tt-item.data-implant ,"00:00:00")
      c-campo = AddEleChar(c-technical, "TechnicalDescription", tt-item.desc-item)
      c-campo = AddEleInt(c-technical, "ManufacturerCode", tt-item.manufacturer)
      
      c-depth = AddElement(c-technical, "Depth")
      c-campo = AddEleDeci(c-depth, "Value", tt-item.comprim)
      c-campo = AddEleChar(c-depth, "LegacyUnitOfMeasure", c-um-dim).

END.

PROCEDURE BuildCommerceView:
    DEF VAR c-commerce AS CHAR.
    DEF VAR c-locale AS CHAR.
    DEF VAR c-state AS CHAR.

    ASSIGN
    c-commerce = AddElement(c-catalogitem, "CommerceView")
      c-campo = AddEleInt(c-commerce, "Type", 1)
      c-campo = AddEleInt(c-commerce, "LeadTimeProcessSales", tt-item.res-for-comp)
      c-campo = AddEleInt(c-commerce, "LeadTimeProcessPurchase", tt-item.res-int-comp + tt-item.res-for-comp)
      c-campo = AddEleInt(c-commerce, "LeadTimeManufacture", tt-item.ressup-fabri)
      c-campo = AddEleInt(c-commerce, "LeadTimeShipping", 0)
      c-campo = AddEleInt(c-commerce, "LeadTimeTransport", 0)
      c-campo = AddEleInt(c-commerce, "LeadTimeReceive", 0)
      c-campo = AddEleInt(c-commerce, "LeadTimeQualityControl", tt-item.res-cq-comp)
      c-campo = AddEleDeci(c-commerce, "MinimumOrderValue", tt-item.lote-multipl)
      c-campo = AddEleDeci(c-commerce, "MaximumOrderValue", 0.0)
      c-campo = AddEleDeci(c-commerce, "MultipleLot", tt-item.lote-multipl)
      c-campo = AddEleDeci(c-commerce, "EconomicLot", tt-item.lote-econom)
      c-campo = AddEleChar(c-commerce, "PartialDelivery", IF FALSE THEN "true" ELSE "false")
      c-campo = AddEleChar(c-commerce, "CancelOrder", IF FALSE THEN "true" ELSE "false")
      c-campo = AddEleDeci(c-commerce, "ScrapRate", tt-item.fator-refugo)
      c-campo = AddEleDeci(c-commerce, "ShrinkageQuantity", tt-item.quant-perda)
      c-campo = AddEleInt(c-commerce, "PurchaseLeadTime", tt-item.res-int-comp)
      c-campo = AddEleInt(c-commerce, "SalesLeadTime", tt-item.ressup-fabri)
      c-campo = AddEleDate(c-commerce, "RegisterDate", tt-item.data-implant,"00:00:00")
      c-campo = AddEleDeci(c-commerce, "BalanceOrderCancel", 0.0)
      c-campo = AddEleInt(c-commerce, "LeadTimeGenerate", 0)
      c-campo = AddEleInt(c-commerce, "CriticalClassification", tt-item.criticidade)
      c-campo = AddEleChar(c-commerce, "FractionalQuantity", IF tt-item.fraciona THEN "true" ELSE "false")
      c-campo = Addelechar(c-commerce, "Buyer" , tt-item.cod-comprado)
      c-locale = AddElement(c-commerce, "CommerceViewLocale")
      c-campo = AddEleChar(c-locale, "Description", tt-item.desc-item)

      c-state = AddElement(c-commerce, "CommerceViewState")
      c-campo = AddEleChar(c-state, "State", c-state-value)
      c-campo = AddEleDate(c-state, "InitialDate", tt-item.data-implant,"00:00:00")
      c-campo = AddEleDate(c-state, "FinalDate", (tt-item.data-implant + (2 * 365)),"00:00:00").

END.

PROCEDURE BuildInventoryView:
    DEF VAR c-inventory AS CHAR.
    DEF VAR c-reorder AS CHAR.
    DEF VAR c-sftystckmin AS CHAR.
    DEF VAR c-sftystckmax AS CHAR.
    DEF VAR c-stckmin AS CHAR.
    DEF VAR c-stckmax AS CHAR.
    DEF VAR c-state AS CHAR.

    ASSIGN
    c-inventory = AddElement(c-catalogitem, "InventoryView")
      c-campo = AddEleChar(c-inventory, "StockCondition", "")
      c-campo = AddEleDeci(c-inventory, "ReorderPoint", tt-item.reorder)
      c-campo = AddEleChar(c-inventory, "Warehouse", tt-item.deposito-pad)
      c-campo = AddEleInt(c-inventory, "ForecastHorizon", 0)
      c-campo = AddEleInt(c-inventory, "ForecastPeriod", 0)
      c-campo = AddEleDeci(c-inventory, "SafetyStock", tt-item.quant-segur)
      c-campo = AddEleInt(c-inventory, "SafetyStockUnit", tt-item.tipo-est-seg)
      c-campo = AddEleDeci(c-inventory, "MinimumStock", 0.0)
      c-campo = AddEleDeci(c-inventory, "MaximumStock", tt-item.cap-est-fabr)
      c-campo = AddEleInt(c-inventory, "StockUnit", 0)
      c-campo = AddEleDeci(c-inventory, "SafetyStockMinimumTolerance", 1.0)
      c-campo = AddEleDeci(c-inventory, "SafetyStockMaximumTolerance", 1.0)
      c-campo = AddEleDeci(c-inventory, "StockMinimumTolerance", 1.0)
      c-campo = AddEleDeci(c-inventory, "StockMaximumTolerance", 1.0)

      c-state = AddElement(c-inventory, "InventoryViewState")
      c-campo = AddEleChar(c-state, "State", c-state-value)
      c-campo = AddEleDate(c-state, "InitialDate", tt-item.data-implant,"00:00:00")
      c-campo = AddEleDate(c-state, "FinalDate", (tt-item.data-implant + (2 * 365)),"00:00:00").

END.

PROCEDURE BuildFromRole:
    DEF VAR c-fromrole                    AS CHAR.
    DEF VAR c-contactinformation-fromrole AS CHAR.
    DEF VAR c-address-fromrole            AS CHAR.
    
    FIND tt-from-role.
        
    ASSIGN
    c-fromrole = AddElement(c-catalogitemng,"FromRole")
      c-campo  = AddEleChar(c-fromrole,"LegacyLocationIdentifier", tt-from-role.local-orig)
      c-campo  = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","Customer")
      c-contactinformation-fromrole = AddElement(c-fromrole,"ContactInformation")
        c-campo = AddEleChar(c-contactinformation-fromrole,"ContactName", tt-from-role.contato-orig-nome)
        c-campo = AddEleChar(c-contactinformation-fromrole,"TelephoneNumber", tt-from-role.contato-orig-fone)
        c-campo = AddEleChar(c-contactinformation-fromrole,"EmailAddress", tt-from-role.contato-orig-email).     
END.

PROCEDURE BuildToRole:
    DEF VAR c-torole                    AS CHAR.
    DEF VAR c-contactinformation-torole AS CHAR.
    DEF VAR c-address-torole            AS CHAR.

    find tt-to-role.
        
    ASSIGN
    c-torole = AddElement(c-catalogitemng,"ToRole")
      c-campo  = AddEleChar(c-torole,"LegacyLocationIdentifier", tt-to-role.local-dest)
      c-campo  = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","Customer")
      c-contactinformation-torole = AddElement(c-torole,"ContactInformation")
        c-campo = AddEleChar(c-contactinformation-torole,"ContactName", tt-to-role.contato-dest-nome)
        c-campo = AddEleChar(c-contactinformation-torole,"TelephoneNumber", tt-to-role.contato-dest-fone)
        c-campo = AddEleChar(c-contactinformation-torole,"EmailAddress", tt-to-role.contato-dest-email).     
END.

/*
**
** END PROCEDURE DEFINITION
**
*/

