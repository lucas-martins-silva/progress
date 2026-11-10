/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEEN055 2.00.02.007 } /*** 010207 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneen055 MAN}
&ENDIF

/******************************************************************************
**  Programa: aneen055.p
**  Funcao  : Sender do item
**  Data    : 04/2007
**  Autor   : Anderson Luiz Rodrigues Silvano
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEF INPUT PARAM p-rowid         AS ROWID                     NO-UNDO.
DEF INPUT PARAM c-cod-estabel   LIKE estabelec.cod-estabel   NO-UNDO.
DEF INPUT PARAM i-cod-emitente  LIKE emitente.cod-emitente   NO-UNDO.
DEF INPUT PARAM c-acao          AS CHAR                      NO-UNDO.
                                                             
DEF VAR c-root                  AS CHAR                      NO-UNDO.
DEF VAR c-message               AS CHAR                      NO-UNDO.
DEF VAR c-campo                 AS CHAR                      NO-UNDO.
DEF VAR c-CatalogItemNG         AS CHAR                      NO-UNDO.
DEF VAR c-CatalogItem           AS CHAR                      NO-UNDO.
DEF VAR c-CatalogItemCollection AS CHAR                      NO-UNDO.
DEF VAR c-State-Value           AS CHAR INITIAL "ACTIVE"     NO-UNDO.
DEF VAR c-FromUOM               AS CHAR                      NO-UNDO.
DEF VAR c-ToUOM                 AS CHAR                      NO-UNDO.
DEF VAR c-FromRole              AS CHAR                      NO-UNDO.
DEF VAR c-ToRole                AS CHAR                      NO-UNDO.
DEF VAR c-commerce              AS CHAR                      NO-UNDO.
                                                             
DEFINE VARIABLE h-cdapi995      AS HANDLE                    NO-UNDO.
DEFINE VARIABLE de-aliq-pis     AS DECIMAL FORMAT ">9.9999"  NO-UNDO.
DEFINE VARIABLE de-aliq-cofins  AS DECIMAL FORMAT ">9.9999"  NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

DEFINE TEMP-TABLE tt-embal NO-UNDO
    FIELD sigla-emb LIKE item-caixa.sigla-emb 
    FIELD qt-item   LIKE item-caixa.qt-item
    INDEX sigla sigla-emb.

{adapters/neogrid/include/anein004.i} /*sender*/

{include/i-epc200.i "aneen055"} /*---- Defini»„es para uso de EPC ----*/

{cdp/cdcfgdis.i}

IF  p-rowid <> ? THEN DO:
    FIND ITEM WHERE ROWID(ITEM) = p-rowid NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN DO:
       RUN pi-cabecalho-msg.    
       RUN pi-corpo-msg.
       RUN pi-rodape-msg.
       WRITExml().
       /*************************** Chamada EPC ******************************/
       IF  c-nom-prog-dpc-mg97  <> "" 
       OR  c-nom-prog-appc-mg97 <> "" 
       OR  c-nom-prog-upc-mg97  <> "" THEN DO:
           
           FOR EACH tt-epc:
               DELETE tt-epc.
           END.
           CREATE tt-epc.
           ASSIGN tt-epc.cod-event     = "EndSenderItemB2B"
                  tt-epc.cod-parameter = "Rowid"
                  tt-epc.val-parameter = STRING(p-rowid).
       
           {include/i-epc201.i "EndSenderItemB2B"}
           
           FOR EACH tt-epc:
               DELETE tt-epc.
           END.                                
        END.
       
       /******************************* Fim EPC **********************************/

    END.
END.

PROCEDURE pi-cabecalho-msg:

    DEF VAR c-SupplierInformation AS CHAR NO-UNDO.

    ASSIGN c-root = CreateNeoGridDoc("CatalogueItemImportNG", "1.01.001", "not used")
             c-message                   = AddElement(c-root,"CRM")
             c-message                   = AddElement(c-root,"Message")
               c-CatalogItemNG           = AddElement(c-message,"CatalogueItemNG")
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
             c-campo     = AddEleChar(c-CatalogItem, "Type","PRODUTO")
             c-campo     = AddEleChar(c-CatalogItem, "Action",c-acao)
             c-campo     = AddEleChar(c-CatalogItem, "ItemIdentifier", item.it-codigo)
             c-campo     = AddEleDate(c-CatalogItem, "RegisterDate", item.data-implant, "00:00:00")
             c-campo     = AddEleChar(c-CatalogItem, "Reference", item.cod-refer)
             c-campo     = AddEleChar(c-CatalogItem, "SubType", IF item.tipo-contr < 4 OR item.tipo-contr = 0 THEN "NORMAL" ELSE "DEBITO-DIRETO")
             c-campo     = AddEleChar(c-CatalogItem, "OldCode", item.it-codigo)
             c-campo     = AddEleChar(c-CatalogItem, "LegacyUnitOfMeasure", item.un)
             c-campo     = AddEleChar(c-CatalogItem, "MaterialFamily", item.fm-codigo)
             c-campo     = AddEleChar(c-CatalogItem, "CommercialFamily", item.fm-cod-com)
             c-campo     = AddEleDeci(c-CatalogItem, "AliquotaIPI", item.aliquota-ipi).

    RUN BuildCatalogueItemState.
    RUN BuildCatalogueItemLocale.
    RUN BuildPackageInformation.
    RUN BuildTechnicalView.
    RUN BuildCommerceView.
    RUN BuildInventoryView.

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
             c-campo = AddEleInt (c-State, "StateCode", item.cod-obsoleto)
             c-campo = AddEleDate(c-State, "InitialDate", item.data-implant,"00:00:00")
             c-campo = AddEleDate(c-State, "FinalDate", (item.data-implant + (2 * 365)),"00:00:00").

END.

PROCEDURE BuildCatalogueItemLocale:
    DEF VAR c-Locale AS CHAR.

    ASSIGN c-Locale  = AddElement(c-CatalogItem, "CatalogueItemLocale")
             c-campo = AddEleChar(c-Locale, "ItemName", item.desc-item)
             c-campo = AddEleChar(c-Locale, "ItemDescription", item.narrativa)
             c-campo = AddEleInt(c-Locale, "LocaleID", 3). /* portugues brasil */

END.

PROCEDURE BuildPackageInformation:

    DEFINE VARIABLE c-PackageInformation AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-packinfo AS CHARACTER  NO-UNDO.

    FOR EACH tt-embal:
        DELETE tt-embal.
    END.

    FOR EACH item-caixa WHERE item-caixa.it-codigo = ITEM.it-codigo
        NO-LOCK:
        IF NOT CAN-FIND(tt-embal WHERE tt-embal.sigla-emb = item-caixa.sigla-emb) THEN DO:
            CREATE tt-embal.
            ASSIGN tt-embal.sigla-emb = item-caixa.sigla-emb
                   tt-embal.qt-item   = item-caixa.qt-item.
        END.
    END.
    FOR EACH item-caixa WHERE item-caixa.fm-cod-com = item.fm-cod-com 
        NO-LOCK:
        IF NOT CAN-FIND(tt-embal WHERE tt-embal.sigla-emb = item-caixa.sigla-emb) THEN DO:
            CREATE tt-embal.
            ASSIGN tt-embal.sigla-emb = item-caixa.sigla-emb
                   tt-embal.qt-item   = item-caixa.qt-item.
        END.
    END.
    FOR EACH item-caixa WHERE item-caixa.fm-codigo = item.fm-codigo
        NO-LOCK:
        IF NOT CAN-FIND(tt-embal WHERE tt-embal.sigla-emb = item-caixa.sigla-emb) THEN DO:
            CREATE tt-embal.
            ASSIGN tt-embal.sigla-emb = item-caixa.sigla-emb
                   tt-embal.qt-item   = item-caixa.qt-item.
        END.
    END.

    ASSIGN c-packinfo = AddElement(c-CatalogItem, "PackageInformationCollection").

    FOR EACH tt-embal:

        FOR FIRST embalag WHERE embalag.sigla-emb = tt-embal.sigla-emb NO-LOCK:

            ASSIGN c-PackageInformation = AddElement(c-packinfo, "PackageInformation")
                   c-campo = AddEleChar(c-PackageInformation, "Description", embalag.descricao)
                   c-campo = AddEleChar(c-PackageInformation, "Code", tt-embal.sigla-emb)
                   c-campo = AddEleDeci(c-PackageInformation, "Quantity", tt-embal.qt-item).
        END.

    END.


END PROCEDURE.

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
    /*DEF VAR c-commerce AS CHAR NO-UNDO.*/
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
             c-campo   = AddEleChar(c-commerce, "FiscalSortKey",ITEM.class-fiscal).

             RUN pi-informacoes-fiscais.

             ASSIGN
             c-locale  = AddElement(c-commerce, "CommerceViewLocale")
               c-campo = AddEleChar(c-locale, "Description", item.desc-item)

             c-state   = AddElement(c-commerce, "CommerceViewState")
               c-campo = AddEleChar(c-state, "State", c-state-value)
               c-campo = AddEleDate(c-state, "InitialDate", item.data-implant,"00:00:00")
               c-campo = AddEleDate(c-state, "FinalDate", (item.data-implant + (2 * 365)),"00:00:00").

END.

PROCEDURE pi-informacoes-fiscais:
    /***
    Desenvolvimento conforme engenharia de OS :
    ~\~\itaguacu~\pastahst~\EMS20~\Logistics Solutions~\Distribui»’o~\28 - CRM~\Pasta Projeto~\Engenharias de OS~\Eng_CRM_Sender_Inf_Fiscais_Itens
    --- Informa»„es referentes ao programa cd0903 (Atualiza»’o Itens Faturamento), pasta Fiscal ---
    ***/

    DEFINE VARIABLE c-cd-trib-icms    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cd-trib-ipi     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cd-trib-iss     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-ind-imp-desc    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-compr-fabric    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-codigo-orig     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-tipo-contr      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-tipo-con-est    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-codigo-orig     AS INTEGER    NO-UNDO.
    

    FOR FIRST fam-comerc FIELDS(un)
        WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-LOCK:
    END.
    FOR FIRST familia FIELDS(un)
        WHERE familia.fm-codigo = item.fm-codigo NO-LOCK:
    END.

    ASSIGN c-cd-trib-icms = {ininc/i01in245.i 04 item.cd-trib-icm}
           c-cd-trib-ipi  = {ininc/i10in172.i 04 item.cd-trib-ipi}
           c-cd-trib-iss  = {ininc/i11in172.i 04 item.cd-trib-iss}
           c-ind-imp-desc = {ininc/i10in122.i 04 item.ind-imp-desc}
           c-compr-fabric = {ininc/i01in172.i 04 item.compr-fabric}
           i-codigo-orig  = item.codigo-orig + 1
           c-codigo-orig  = {ininc/i18in122.i 04  i-codigo-orig}
           c-tipo-contr   = {ininc/i09in122.i 04 item.tipo-contr}
           c-tipo-con-est = {ininc/i01in122.i 04 item.tipo-con-est}.
    
    IF NOT VALID-HANDLE (h-cdapi995)  THEN
        RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

    RUN recupera-aliquotas IN h-cdapi995 (INPUT "item",
                                          INPUT ITEM.it-codigo,
                                          OUTPUT de-aliq-pis,
                                          OUTPUT de-aliq-cofins).
    
    IF de-aliq-pis    = 0 THEN ASSIGN de-aliq-pis     = dec(substring(item.char-2,31,5)).
    IF de-aliq-cofins = 0  THEN ASSIGN de-aliq-cofins = dec(substring(item.char-2,36,5)).

    ASSIGN c-campo   = AddEleInt(c-commerce, "cod-ncm",int(item.dec-1))
           c-campo   = AddEleInt(c-commerce, "cod-servico",item.cod-servico)
           c-campo   = AddEleDeci(c-commerce, "fator-reaj-icms",item.fator-reaj-icms)
           c-campo   = AddEleDeci(c-commerce, "aliquota-iss",item.aliquota-iss)
           &IF '{&BF_DIS_VERSAO_EMS}' < '2.071' &THEN
           c-campo   = AddEleChar(c-commerce, "nr-item-dcr",substr(item.char-2,217,12))
           &ELSE
           c-campo   = AddEleChar(c-commerce, "nr-item-dcr",item.cod-dcr-item)
           &ENDIF
           c-campo   = AddEleDeci(c-commerce, "aliquota-pis",de-aliq-pis)
           c-campo   = AddEleDeci(c-commerce, "reducao-pis",dec(substring(item.char-2,41,5)))
           c-campo   = AddEleDeci(c-commerce, "aliquota-cofins",de-aliq-cofins)
           c-campo   = AddEleDeci(c-commerce, "reducao-cofins",dec(substring(item.char-2,46,5)))
           c-campo   = AddEleChar(c-commerce, "cd-trib-icms",c-cd-trib-icms)
           c-campo   = AddEleChar(c-commerce, "cd-trib-ipi",c-cd-trib-ipi)
           c-campo   = AddEleChar(c-commerce, "cd-trib-iss",c-cd-trib-iss)
           c-campo   = AddEleChar(c-commerce, "origem-pis",if  substring(item.char-2,52,1) = "1" then "Item" else "Natureza")
           c-campo   = AddEleChar(c-commerce, "origem-cofins",if  substr(item.char-2,53,1) = "1" then "Item" else "Natureza")
           c-campo   = AddEleChar(c-commerce, "susp-ipi",if  substr(item.char-2,51,1) = "1" then "Sim" else "N’o")
           c-campo   = AddEleChar(c-commerce, "ind-ipi-dife", if  item.ind-ipi-dife then "Sim" else "N’o")
           c-campo   = AddEleDeci(c-commerce, "valor-ipi-bebida", item.valor-ipi-beb)
           c-campo   = AddEleChar(c-commerce, "incentivado", if  item.incentivado then "Sim" else "N’o")
           c-campo   = AddEleChar(c-commerce, "pis-cofins-subst-total", IF substr(item.char-1,50,5) = "Sim" THEN "Sim" ELSE "N’o")
           c-campo   = AddEleInt(c-commerce, "horiz-fixo", item.horiz-fixo)
           c-campo   = AddEleChar(c-commerce, "ind-imp-desc", c-ind-imp-desc)
           c-campo   = AddEleChar(c-commerce, "un-fam-comerc", if  avail fam-comerc then fam-comerc.un else "")
           c-campo   = AddEleDeci(c-commerce, "ft-conv-fmcoml", item.ft-conv-fmcoml)
           c-campo   = AddEleInt(c-commerce, "dec-conv-fmcoml", item.dec-conv-fmcoml)
           c-campo   = AddEleChar(c-commerce, "un-fam", if  avail familia then familia.un else "")
           c-campo   = AddEleDeci(c-commerce, "ft-conversao", item.ft-conversao)
           c-campo   = AddEleInt(c-commerce, "dec-ftcon", item.dec-ftcon)
           c-campo   = AddEleChar(c-commerce, "compr-fabric", c-compr-fabric)
           c-campo   = AddEleDeci(c-commerce, "lote-mulven", item.lote-mulven)
           c-campo   = AddEleDeci(c-commerce, "fator-conver", item.fator-conver)
           c-campo   = AddEleInt(c-commerce, "cod-tax-serv", item.cod-tax-serv)
           c-campo   = AddEleChar(c-commerce, "ind-especifico", if item.ind-especifico then "Sim" else "N’o")
           c-campo   = AddEleChar(c-commerce, "cod-localiz", item.cod-localiz)
           c-campo   = AddEleChar(c-commerce, "codigo-orig", c-codigo-orig)
           c-campo   = AddEleChar(c-commerce, "ind-item-fat", if  item.ind-item-fat then "Sim" else "N’o")
           c-campo   = AddEleChar(c-commerce, "ind-inf-qtf", if  item.ind-inf-qtf then "Sim" else "N’o")
           c-campo   = AddEleChar(c-commerce, "baixa-estoq", if  item.baixa-estoq then "Sim" else "N’o")
           c-campo   = AddEleChar(c-commerce, "loc-unica", if  item.loc-unica then "Sim" else "N’o")
           c-campo   = AddEleChar(c-commerce, "tipo-contr", c-tipo-contr)
           c-campo   = AddEleChar(c-commerce, "tipo-con-est", c-tipo-con-est)
           c-campo   = AddEleChar(c-commerce, "Buyer", item.cod-comprado).

    IF VALID-HANDLE(h-cdapi995) THEN DO:
        RUN pi-finalizar in h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.
END PROCEDURE.

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
             c-campo   = AddEleDeci(c-inventory, "BasePrice",ITEM.preco-base)
             c-campo   = AddEleDeci(c-inventory, "PriceLastEntry",ITEM.preco-ul-ent)
             c-campo   = AddEleDeci(c-inventory, "PriceReplacement",ITEM.preco-repos)
             c-campo   = AddEleDeci(c-inventory, "TaxRate",ITEM.preco-fiscal)
             c-campo   = AddEleInt(c-inventory, "TypeUnitCost",1)

           c-state     = AddElement(c-inventory, "InventoryViewState")
             c-campo   = AddEleChar(c-state, "State", c-state-value)
             c-campo   = AddEleDate(c-state, "InitialDate", item.data-implant,"00:00:00")
             c-campo   = AddEleDate(c-state, "FinalDate", (item.data-implant + (2 * 365)),"00:00:00").

END.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo   = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo   = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                      THEN STRING(i-cod-emitente)
                                                                      ELSE "")
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF



