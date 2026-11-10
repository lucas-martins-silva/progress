PROCEDURE PITransUpsert:
    /* PARAMETERS*/
    DEFINE INPUT  PARAM pTranAction           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pProgName             AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-item-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-item-estab-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-refer-item-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-estrut-item-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-ref-it-estrut-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-rot-item-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-operac-engr.
    DEFINE INPUT  PARAM TABLE FOR tt-op-ferr-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-ord-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-op-ord-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-res-ord-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-sdo-estoq-dbr .
    DEFINE INPUT  PARAM TABLE FOR tt-pdven-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-proces-item-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-ctrab-op-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz  AS DECIMAL   INITIAL ? NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.


    /* LOCAL VARIABLES */
    DEFINE VAR iIdItem                    AS INTEGER INITIAL 1 NO-UNDO. 
    DEFINE VAR iIdReference               AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdComponentReferences     AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdSite                    AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdItemRouting             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdOperationInformation    AS INTEGER INITIAL 1 NO-UNDO. 
    DEFINE VAR iIdToolsPerOperationInform AS INTEGER INITIAL 1 NO-UNDO. 
    DEFINE VAR iIdStructure               AS INTEGER INITIAL 1 NO-UNDO.   
    DEFINE VAR iIdProductionOrder         AS INTEGER INITIAL 1 NO-UNDO.   
    DEFINE VAR iIdOperationOrderInform    AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdReservesInformations    AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdInventoryInformation    AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdSalesOrder              AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdVariableProcess         AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdProcessItem             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VAR iIdBalanceThird            AS INTEGER INITIAL 1 NO-UNDO.
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    EMPTY TEMP-TABLE tt-erro                      NO-ERROR.
    EMPTY TEMP-TABLE ttItem                       NO-ERROR.
    EMPTY TEMP-TABLE ttSite                       NO-ERROR.
    EMPTY TEMP-TABLE ttReference                  NO-ERROR.
    EMPTY TEMP-TABLE ttStructure                  NO-ERROR.
    EMPTY TEMP-TABLE ttComponentReferences        NO-ERROR.
    EMPTY TEMP-TABLE ttItemRouting                NO-ERROR.
    EMPTY TEMP-TABLE ttOperationInformation       NO-ERROR.
    EMPTY TEMP-TABLE ttToolsPerOperationInform_00 NO-ERROR.
    EMPTY TEMP-TABLE ttProductionOrder            NO-ERROR.
    EMPTY TEMP-TABLE ttOperationOrderInformation  NO-ERROR.
    EMPTY TEMP-TABLE ttReservesInformations       NO-ERROR.
    EMPTY TEMP-TABLE ttInventoryInformations      NO-ERROR.
    EMPTY TEMP-TABLE ttSalesOrder                 NO-ERROR.
    EMPTY TEMP-TABLE ttProcessItem                NO-ERROR.
    EMPTY TEMP-TABLE ttVariableProcess            NO-ERROR.
    
    IF  NOT CAN-FIND (FIRST tt-item-dbr) THEN DO: 

        /* Registro Item nao encontrado */
        {utp/ut-liter.i Item_para_Integracao_EAI *}
        RUN utp/ut-msgs.p("msg":U,
                          5561,
                          RETURN-VALUE).
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK":U.
    END.

    /* Cria temp-tables do adapter com base nas temp-tables enviadas pelo EMS               */
    /* O adapter ir  considerar valores branco/zero pois o default dos campos j  foi setado */

    FIND FIRST tt-item-dbr NO-ERROR.
    IF  AVAIL tt-item-dbr THEN DO:

        CREATE ttItem.
        ASSIGN ttItem.ItemCode                         = tt-item-dbr.it-codigo
               ttItem.ItemDescription                  = tt-item-dbr.desc-item
               ttItem.MaterialFamilyCode               = tt-item-dbr.fm-codigo
               ttItem.InventoryGroupCode               = tt-item-dbr.ge-codigo
               ttItem.UnitOfMeasureCode                = tt-item-dbr.un
               ttItem.DefaultSiteCode                  = tt-item-dbr.cod-estabel 
               ttItem.ItemStatus                       = tt-item-dbr.cod-obsoleto
               ttItem.CommercialFamilyCode             = tt-item-dbr.fm-cod-com
               ttItem.BougthOrManufacturedItem         = tt-item-dbr.compr-fabric
               ttItem.ScrapFactor                      = tt-item-dbr.fator-refugo
               ttItem.OrderDivision                    = tt-item-dbr.div-ordem
               ttItem.EconomicLot                      = tt-item-dbr.lote-economi
               ttItem.MultipleBatch                    = tt-item-dbr.lote-multipl
               ttItem.MinimumLot                       = tt-item-dbr.lote-minimo
               ttItem.InventoryControlType             = tt-item-dbr.tipo-con-est
               ttItem.FixedPeriod                      = tt-item-dbr.periodo-fixo
               ttItem.QualityControlLeadTime           = tt-item-dbr.res-cq-comp
               ttItem.ManufactureLeadTime              = tt-item-dbr.ressup-fabri
               ttItem.ManufactureAndQualityControlL_00 = tt-item-dbr.res-cq-fab
               ttItem.VendorLeadTime                   = tt-item-dbr.res-for-comp
               ttItem.PurchasingLeadTime               = tt-item-dbr.res-int-comp
               ttItem.SafetyStockControlType           = tt-item-dbr.tipo-est-seg
               ttItem.SafetyTime                       = tt-item-dbr.tempo-segur
               ttItem.SafetyStock                      = tt-item-dbr.quant-segur
               ttItem.WasteQuantity                    = tt-item-dbr.quant-perda
               ttItem.FixedHorizon                     = tt-item-dbr.horiz-fixo
               ttItem.PlannerCode                      = tt-item-dbr.cd-planejado
               ttItem.IsFractionizedQuantityItem       = tt-item-dbr.fraciona
               ttItem.Policy                           = tt-item-dbr.politica
               ttItem.Priority                         = tt-item-dbr.num-priorid
               ttItem.LowerLevel                       = tt-item-dbr.niv-mais-bai
               ttItem.BuyerCode                        = tt-item-dbr.cod-comprador
               ttItem.ttItemId                         = iIdItem
               iIdItem                                 = iIdItem + 1.

        FOR EACH tt-refer-item-dbr:

            CREATE ttReference.
            ASSIGN ttReference.ReferenceCode = tt-refer-item-dbr.cod-refer
                   ttReference.ttReferenceID = iIdReference
                   iIdReference              = iIdReference + 1.
        END.

        FOR EACH tt-item-estab-dbr:

            CREATE ttSite.
            ASSIGN ttSite.EconomicLot                      = tt-item-estab-dbr.lote-economi
                   ttSite.FixedHorizon                     = tt-item-estab-dbr.horiz-fixo
                   ttSite.FixedPeriod                      = tt-item-estab-dbr.periodo-fixo
                   ttSite.ItemStatus                       = tt-item-estab-dbr.cod-obsoleto
                   ttSite.ManufactureAndQualityControlL_00 = tt-item-estab-dbr.res-cq-fabri
                   ttSite.ManufactureLeadTime              = tt-item-estab-dbr.ressup-fabri
                   ttSite.MinimumLot                       = tt-item-estab-dbr.lote-minimo
                   ttSite.MultipleBatch                    = tt-item-estab-dbr.lote-multipl
                   ttSite.OrderDivision                    = tt-item-estab-dbr.div-ordem
                   ttSite.PlannerCode                      = tt-item-estab-dbr.cd-planejado
                   ttSite.Policy                           = tt-item-estab-dbr.politica
                   ttSite.ProductionLineCode               = tt-item-estab-dbr.nr-linha
                   ttSite.QualityControlLeadTime           = tt-item-estab-dbr.res-cq-comp
                   ttSite.SafetyStock                      = tt-item-estab-dbr.quant-segur
                   ttSite.SafetyTime                       = tt-item-estab-dbr.tempo-segur
                   ttSite.ScrapFactor                      = tt-item-estab-dbr.fator-refugo
                   ttSite.SiteCode                         = tt-item-estab-dbr.cod-estabel
                   ttSite.TypeAllot                        = tt-item-estab-dbr.sit-aloc
                   ttSite.VendorLeadTime                   = tt-item-estab-dbr.res-for-comp
                   ttSite.WareHouseCode                    = tt-item-estab-dbr.deposito-pad
                   ttSite.WasteQuantity                    = tt-item-estab-dbr.quant-perda
                   ttSite.BuyerCode                        = tt-item-estab-dbr.cod-comprador
                   ttSite.SafetyStockControlType           = tt-item-estab-dbr.tipo-est-seg
                   ttSite.PurchasingLeadTime               = tt-item-estab-dbr.res-int-comp
                   ttSite.Priority                         = tt-item-estab-dbr.num-priorid
                   ttSite.ttSiteID                         = iIdSite
                   iIdSite                                 = iIdSite + 1.
        END.

        FOR EACH tt-rot-item-dbr:

            CREATE ttItemRouting.
            ASSIGN ttItemRouting.EndDateRouting   = tt-rot-item-dbr.data-termino
                   ttItemRouting.ItemRoutingCode  = tt-rot-item-dbr.cod-roteiro
                   ttItemRouting.RoutingSequence  = tt-rot-item-dbr.sequencia
                   ttItemRouting.StartDateRouting = tt-rot-item-dbr.data-inicio
                   ttItemRouting.ttItemRoutingID  = iIdItemRouting
                   iIdItemRouting                 = iIdItemRouting + 1.
        END.
                   
        FOR EACH  tt-operac-engr:
    
            CREATE ttOperationInformation.
            ASSIGN ttOperationInformation.FinishlDate              = tt-operac-engr.data-termino
                   ttOperationInformation.InitialDate              = tt-operac-engr.data-inicio
                   ttOperationInformation.IsSignificantTime        = tt-operac-engr.tempo-sig
                   ttOperationInformation.MachineHours             = tt-operac-engr.tempo-maquin
                   ttOperationInformation.ManHours                 = tt-operac-engr.tempo-homem
                   ttOperationInformation.OperationCode            = tt-operac-engr.op-codigo
                   ttOperationInformation.OperationDescription     = tt-operac-engr.descricao
                   ttOperationInformation.OperationType            = tt-operac-engr.tipo-oper
                   ttOperationInformation.SetupTime                = tt-operac-engr.tempo-prepar
                   ttOperationInformation.StandardOperationCode    = tt-operac-engr.nr-oper-pad
                   ttOperationInformation.Units                    = tt-operac-engr.nr-unidades
                   ttOperationInformation.WorkCenterCode           = tt-operac-engr.gm-codigo
                   ttOperationInformation.SetupReductionCode       = tt-operac-engr.cod-reduc-prepar
                   ttOperationInformation.OperationId              = tt-operac-engr.num-id-operacao
                   ttOperationInformation.ttOperationInformationID = iIdOperationInformation.
                   
            FOR EACH  tt-op-ferr-dbr 
                WHERE tt-op-ferr-dbr.num-id-operacao = tt-operac-engr.num-id-operacao:
    
                CREATE ttToolsPerOperationInform_00.
                ASSIGN ttToolsPerOperationInform_00.AlternativeOperationCode       = tt-op-ferr-dbr.op-altern
                       ttToolsPerOperationInform_00.OperationId                    = tt-op-ferr-dbr.num-id-operacao
                       ttToolsPerOperationInform_00.SequenceCode                   = tt-op-ferr-dbr.sequencia
                       ttToolsPerOperationInform_00.ToolCode                       = tt-op-ferr-dbr.ferramenta
                       ttToolsPerOperationInform_00.ttOperationInformationID       = iIdOperationInformation
                       ttToolsPerOperationInform_00.ttToolsPerOperationInform_00ID = iIdToolsPerOperationInform
                       iIdToolsPerOperationInform                                  = iIdToolsPerOperationInform + 1. 
            END.

            FOR EACH  tt-ctrab-op-dbr WHERE tt-ctrab-op-dbr.num-id-operacao =  tt-operac-engr.num-id-operac NO-LOCK:
                
                 CREATE ttOperationWorkCenterInform.
                 ASSIGN ttOperationWorkCenterInform.ttOperationInformationID = tt-ctrab-op-dbr.num-id-operacao
                        ttOperationWorkCenterInform.AlternativeOperationCode = tt-ctrab-op-dbr.op-altern
                        ttOperationWorkCenterInform.WorkCenterCode           = tt-ctrab-op-dbr.cod-ctrab
                        ttOperationWorkCenterInform.Priority                 = tt-ctrab-op-dbr.prioridade
                        ttOperationWorkCenterInform.Performance              = tt-ctrab-op-dbr.val-perform.
             END.
    
            ASSIGN iIdOperationInformation = iIdOperationInformation + 1.
        END.

        FOR EACH tt-estrut-item-dbr:

            CREATE ttStructure.
            ASSIGN ttStructure.ComponentCode         = tt-estrut-item-dbr.es-codigo
                   ttStructure.ComponentProportion   = tt-estrut-item-dbr.proporcao
                   ttStructure.ComponentQuantity     = tt-estrut-item-dbr.qtd-compon
                   ttStructure.EndDate               = tt-estrut-item-dbr.data-termino
                   ttStructure.ExcessiveMaterialType = tt-estrut-item-dbr.tipo-sobra
                   ttStructure.IsPhantom             = tt-estrut-item-dbr.fantasma
                   ttStructure.ItemQuantity          = tt-estrut-item-dbr.qtd-item
                   ttStructure.OperationCode         = tt-estrut-item-dbr.op-codigo
                   ttStructure.RoutingCode           = tt-estrut-item-dbr.cod-roteiro
                   ttStructure.SequenceNumber        = tt-estrut-item-dbr.sequencia
                   ttStructure.StartDate             = tt-estrut-item-dbr.data-inicio
                   ttStructure.ComponentListCode     = tt-estrut-item-dbr.cod-lista-compon
                   ttStructure.ttStructureID         = iIdStructure.
                   
            FOR EACH  tt-ref-it-estrut-dbr 
                WHERE tt-ref-it-estrut-dbr.sequencia = tt-estrut-item-dbr.sequencia
                AND   tt-ref-it-estrut-dbr.es-codigo = tt-estrut-item-dbr.es-codigo:

                CREATE ttComponentReferences.
                ASSIGN ttComponentReferences.ComponentReferenceCode  = tt-ref-it-estrut-dbr.cod-ref-es  
                       ttComponentReferences.ItemReferenceCode       = tt-ref-it-estrut-dbr.cod-ref-it  
                       ttComponentReferences.ttStructureID           = iIdStructure  
                       ttComponentReferences.ttComponentReferencesID = iIdComponentReferences
                       iIdComponentReferences                        = iIdComponentReferences + 1.
            END.

            ASSIGN iIdStructure = iIdStructure + 1.
        END.

        FOR EACH tt-ord-dbr:
            IF tt-ord-dbr.tipo = ? OR 
               tt-ord-dbr.tipo < 1 THEN 
               ASSIGN tt-ord-dbr.tipo = 1.
               
            CREATE ttProductionOrder.
            ASSIGN ttProductionOrder.BalanceQuantity         = tt-ord-dbr.qtd-saldo
                   ttProductionOrder.CustomerName            = tt-ord-dbr.nome-abrev
                   ttProductionOrder.CustomerOrder           = tt-ord-dbr.nr-pedcli
                   ttProductionOrder.CustomerOrderSequence   = tt-ord-dbr.nr-sequencia
                   ttProductionOrder.DeliveryDate            = tt-ord-dbr.dat-entrega
                   ttProductionOrder.OrderItemDelivery       = tt-ord-dbr.nr-entrega
                   ttProductionOrder.OrderType               = tt-ord-dbr.idi-tip-ord-dbr
                   ttProductionOrder.Parcel                  = tt-ord-dbr.parcela
                   ttProductionOrder.PriorityProductionOrder = tt-ord-dbr.prioridade
                   ttProductionOrder.ProductionOrderNumber   = tt-ord-dbr.num-ord-dbr
                   ttProductionOrder.ReferenceCode           = tt-ord-dbr.cod-refer
                   ttProductionOrder.SiteCode                = tt-ord-dbr.cod-estabel
                   ttProductionOrder.StartDate               = tt-ord-dbr.dat-inicio
                   ttProductionOrder.ProductionOrderType     = tt-ord-dbr.tipo
                   ttProductionOrder.OrderQuantity           = tt-ord-dbr.qt-ordem
                   ttProductionOrder.ttProductionOrderID     = iIdProductionOrder.
            
                                                                                  
            FOR EACH  tt-op-ord-dbr
                WHERE tt-op-ord-dbr.nr-ord-produ = tt-ord-dbr.num-ord-dbr:

                CREATE ttOperationOrderInformation.
                ASSIGN ttOperationOrderInformation.ItemCode                      = tt-op-ord-dbr.it-codigo
                       ttOperationOrderInformation.IsSignificantTime             = tt-op-ord-dbr.tempo-sig
                       ttOperationOrderInformation.MachineHours                  = tt-op-ord-dbr.tempo-maquin
                       ttOperationOrderInformation.ManHours                      = tt-op-ord-dbr.tempo-homem
                       ttOperationOrderInformation.OperationID                   = tt-op-ord-dbr.num-id-operacao
                       ttOperationOrderInformation.OperationOrderCode            = tt-op-ord-dbr.op-codigo
                       ttOperationOrderInformation.OperationOrderDescription     = tt-op-ord-dbr.descricao
                       ttOperationOrderInformation.OperationType                 = tt-op-ord-dbr.tipo-oper
                       ttOperationOrderInformation.RemainQuantity                = tt-op-ord-dbr.qtd-prog
                       ttOperationOrderInformation.WorkCenterCode                = tt-op-ord-dbr.cod-ctrab
                       ttOperationOrderInformation.RoutingCode                   = tt-op-ord-dbr.cod-roteiro
                       ttOperationOrderInformation.Sequence                      = tt-op-ord-dbr.sequencia
                       ttOperationOrderInformation.SetupTime                     = tt-op-ord-dbr.tempo-prepar
                       ttOperationOrderInformation.Tool                          = tt-op-ord-dbr.cod-ferram
                       ttOperationOrderInformation.MachineGroupCode              = tt-op-ord-dbr.gm-codigo
                       ttOperationOrderInformation.ttProductionOrderID           = iIdProductionOrder
                       ttOperationOrderInformation.ttOperationOrderInformationID = iIdOperationOrderInform
                       iIdOperationOrderInform                                   = iIdOperationOrderInform + 1.
            END.

            FOR EACH  tt-res-ord-dbr
                WHERE tt-res-ord-dbr.nr-ord-produ = tt-ord-dbr.num-ord-dbr:

                CREATE ttReservesInformations.
                ASSIGN ttReservesInformations.FatherItemCode           = tt-res-ord-dbr.item-pai
                       ttReservesInformations.ItemCode                 = tt-res-ord-dbr.it-codigo
                       ttReservesInformations.BalanceQuantity          = tt-res-ord-dbr.qtd-saldo
                       ttReservesInformations.OperationCode            = tt-res-ord-dbr.op-codigo
                       ttReservesInformations.ReferenceCode            = tt-res-ord-dbr.cod-refer
                       ttReservesInformations.ReserveDate              = tt-res-ord-dbr.dat-reserva-op
                       ttReservesInformations.RoutingCode              = tt-res-ord-dbr.cod-roteiro
                       ttReservesInformations.SurplusType              = tt-res-ord-dbr.tipo-sobra
                       ttReservesInformations.AtendedByOtherOrder      = tt-res-ord-dbr.log-livre-1
                       ttReservesInformations.QuantityBeingAtended     = tt-res-ord-dbr.val-livre-1
                       ttReservesInformations.ttProductionOrderID      = iIdProductionOrder
                       ttReservesInformations.ttReservesInformationsID = iIdReservesInformations
                       iIdReservesInformations                         = iIdReservesInformations + 1. 
            END.

            ASSIGN iIdProductionOrder = iIdProductionOrder + 1.
        END.

        FOR EACH tt-sdo-estoq-dbr:

            CREATE ttInventoryInformations.
            ASSIGN ttInventoryInformations.SiteID                      = tt-sdo-estoq-dbr.cod-estabel
                   ttInventoryInformations.ReferenceCode               = tt-sdo-estoq-dbr.cod-refer
                   ttInventoryInformations.LotCode                     = tt-sdo-estoq-dbr.cod-lote
                   ttInventoryInformations.LotValidityDate             = tt-sdo-estoq-dbr.dat-valid-lote
                   ttInventoryInformations.ImprovementRemittance       = tt-sdo-estoq-dbr.qtd-remes-benef
                   ttInventoryInformations.EntranceForImprovement      = tt-sdo-estoq-dbr.qtd-entr-benef
                   ttInventoryInformations.ConsignmentContractEntrance = tt-sdo-estoq-dbr.qtd-entr-consig
                   ttInventoryInformations.ConsigmentImprovement       = tt-sdo-estoq-dbr.qtd-remes-consig
                   ttInventoryInformations.Off-SiteTransference        = tt-sdo-estoq-dbr.qtd-sdo-transi
                   ttInventoryInformations.On-HandBalance              = tt-sdo-estoq-dbr.qtd-sdo-estoq-dbr
                   ttInventoryInformations.ttInventoryInformationsID   = iIdInventoryInformation
                   iIdInventoryInformation                             = iIdInventoryInformation + 1. 
        END.

        FOR EACH tt-pdven-dbr:

            CREATE ttSalesOrder.
            ASSIGN ttSalesOrder.CreditApprovalCurrentStatus = tt-pdven-dbr.idi-sit-avaliac
                   ttSalesOrder.CustomerOrderNumber         = tt-pdven-dbr.nr-pedcli
                   ttSalesOrder.CustomerShortName           = tt-pdven-dbr.nome-abrev
                   ttSalesOrder.DeliveryDate                = tt-pdven-dbr.dt-entrega
                   ttSalesOrder.DeliverySequence            = tt-pdven-dbr.nr-entrega
                   ttSalesOrder.ItemReferenceCode           = tt-pdven-dbr.cod-refer
                   ttSalesOrder.MainSiteCode                = tt-pdven-dbr.cod-estabel
                   ttSalesOrder.OrderLine                   = tt-pdven-dbr.nr-sequencia
                   ttSalesOrder.Priority                    = tt-pdven-dbr.num-priorid
                   ttSalesOrder.QuantityBalance             = tt-pdven-dbr.qtd-saldo
                   ttSalesOrder.ttSalesOrderID              = iIdSalesOrder
                   iIdSalesOrder                            = iIdSalesOrder + 1.
        END.

        FOR EACH tt-proces-item-dbr:
            IF tt-proces-item-dbr.num-seq = ? OR tt-proces-item-dbr.num-seq = 0 THEN
               ASSIGN tt-proces-item-dbr.num-seq = iIdVariableProcess * 10.

            CREATE ttVariableProcess.
            ASSIGN ttVariableProcess.SequenceNumber      = tt-proces-item-dbr.num-seq          
                   ttVariableProcess.RoutingCode         = tt-proces-item-dbr.cod-roteiro      
                   ttVariableProcess.ReferenceCode       = tt-proces-item-dbr.cod-refer        
                   ttVariableProcess.SiteCode            = tt-proces-item-dbr.cod-estabel     
                   ttVariableProcess.ProductionLineCode  = tt-proces-item-dbr.nr-linha        
                   ttVariableProcess.InitialDate         = tt-proces-item-dbr.data-inicio       
                   ttVariableProcess.FinishDate          = tt-proces-item-dbr.data-termino      
                   ttVariableProcess.MinimumItemQuantity = tt-proces-item-dbr.qtd-min-item      
                   ttVariableProcess.MaximumItemQuantity = tt-proces-item-dbr.qtd-max-item      
                   ttVariableProcess.ProcessDescription  = tt-proces-item-dbr.des-regra-proces 
                   ttVariableProcess.ComponentListCode   = tt-proces-item-dbr.cod-lista-compon
                   ttVariableProcess.ttVariableProcessID = iIdVariableProcess
                   iIdVariableProcess                    = iIdVariableProcess + 1.
        END.

        FOR EACH tt-proces-item-dbr:

            CREATE ttProcessItem.
            ASSIGN ttProcessItem.ItemCode            = tt-proces-item-dbr.it-codigo       
                   ttProcessItem.Sequence            = tt-proces-item-dbr.num-seq         
                   ttProcessItem.Roadmap             = tt-proces-item-dbr.cod-roteiro     
                   ttProcessItem.reference           = tt-proces-item-dbr.cod-refer       
                   ttProcessItem.MinimumItemQuantity = tt-proces-item-dbr.qtd-min-item    
                   ttProcessItem.MaximumItemQuantity = tt-proces-item-dbr.qtd-max-item    
                   ttProcessItem.DefaultSiteCode     = tt-proces-item-dbr.cod-estabel     
                   ttProcessItem.NumberLine          = tt-proces-item-dbr.nr-linha        
                   ttProcessItem.StartDate           = tt-proces-item-dbr.data-inicio     
                   ttProcessItem.EndDate             = tt-proces-item-dbr.data-termino    
                   ttProcessItem.ProcedureRule       = tt-proces-item-dbr.des-regra-proces
                   ttProcessItem.ComponentCodeList   = tt-proces-item-dbr.cod-lista-compon
                   ttProcessItem.ValueRatio          = tt-proces-item-dbr.val-proporcao
                   ttProcessItem.ttProcessItemID     = iIdProcessItem
                   iIdProcessItem                    = iIdProcessItem + 1.
        END.

        FOR EACH tt-sdo-terc-dbr:

            CREATE ttBalanceThird.
            ASSIGN ttBalanceThird.ItemCode                 = tt-sdo-terc-dbr.it-codigo
                   ttBalanceThird.QuantityBalance          = tt-sdo-terc-dbr.quant-saldo
                   ttBalanceThird.ProductionEstablishment  = tt-sdo-terc-dbr.cod-estab-produc
                   ttBalanceThird.RequestingEstablishment  = tt-sdo-terc-dbr.cod-estab-solic
                   ttBalanceThird.TypeBalance              = tt-sdo-terc-dbr.tipo-sal-terc
                   ttBalanceThird.reference                = tt-sdo-terc-dbr.cod-refer
                   ttBalanceThird.Issue                    = tt-sdo-terc-dbr.dat-emissao
                   ttBalanceThird.ttBalanceThirdID         = iIdBalanceThird
                   iIdBalanceThird                         = iIdBalanceThird + 1.
        END.
    END.

    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN PIUpsert (INPUT pTranAction,
                  INPUT pProgName,
                  INPUT pProgVersion,
                  INPUT TABLE ttItem,
                  INPUT TABLE ttSite,
                  INPUT TABLE ttReference,
                  INPUT TABLE ttStructure,
                  INPUT TABLE ttComponentReferences,
                  INPUT TABLE ttItemRouting,
                  INPUT TABLE ttOperationInformation,
                  INPUT TABLE ttToolsPerOperationInform_00,
                  INPUT TABLE ttProductionOrder,
                  INPUT TABLE ttOperationOrderInformation,
                  INPUT TABLE ttReservesInformations,
                  INPUT TABLE ttInventoryInformations,
                  INPUT TABLE ttSalesOrder,
                  INPUT TABLE ttVariableProcess,
                  INPUT TABLE ttOperationWorkCenterInform,
                  INPUT de-val-refer-atualiz,
                  OUTPUT TABLE tt-erro).                     
END.
