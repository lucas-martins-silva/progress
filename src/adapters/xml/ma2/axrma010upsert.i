
CREATE tt-familia.

IF cTranAction = "upd":U THEN DO:
   FIND FIRST familia NO-LOCK
        WHERE familia.fm-codigo = MaterialFamilyCode NO-ERROR.
   IF AVAIL familia THEN
      BUFFER-COPY familia TO tt-familia.
END.

ASSIGN tt-familia.fm-codigo                 = MaterialFamilyCode
       tt-familia.descricao                 = MaterialFamilyDescription
       tt-familia.un                        = UnitOfMeasureCode 
       tt-familia.deposito-pad              = IF WareHouseCode                = ? THEN tt-familia.deposito-pad     ELSE WareHouseCode
       
       tt-familia.tipo-con-est              = IF InventoryControlType         = ? THEN tt-familia.tipo-con-est     ELSE InventoryControlType
       tt-familia.perc-nqa                  = if AcceptanceQualityLevel       = ? then tt-familia.perc-nqa         else AcceptanceQualityLevel      
       tt-familia.var-pre-perm              = if AllowedPriceVariation        = ? then tt-familia.var-pre-perm     else AllowedPriceVariation       
       tt-familia.var-qtd-perm              = if AllowedQuantityVariation     = ? then tt-familia.var-qtd-perm     else AllowedQuantityVariation    
       tt-familia.cd-origem                 = if CodeSource                   = ? then tt-familia.cd-origem        else CodeSource                  
       tt-familia.tipo-contr                = if ControlType                  = ? then tt-familia.tipo-contr       else ControlType                 
       tt-familia.fator-conver              = if ConversionFactor             = ? then tt-familia.fator-conver     else ConversionFactor            
       tt-familia.var-preco                 = if CostVariation                = ? then tt-familia.var-preco        else CostVariation               
       tt-familia.ciclo-contag              = if CountingCicle                = ? then tt-familia.ciclo-contag     else CountingCicle               
       tt-familia.criticidade               = if Criticality                  = ? then tt-familia.criticidade      else Criticality                 
       tt-familia.demanda                   = if DemandType                   = ? then tt-familia.demanda          else DemandType                  
       tt-familia.lote-economi              = if EconomicLot                  = ? then tt-familia.lote-economi     else EconomicLot                 
       tt-familia.tipo-lote-ec              = if EconomicLotType              = ? then tt-familia.tipo-lote-ec     else EconomicLotType             
       tt-familia.nivel-apr-solic           = if EletronicApprovalRequest     = ? then tt-familia.nivel-apr-solic  else EletronicApprovalRequest    
       tt-familia.nivel-apr-requis          = if EletronicApprovalRequisition = ? then tt-familia.nivel-apr-requis else EletronicApprovalRequisition
        
       &IF DEFINED (bf_man_per_ppm) &THEN
       tt-familia.per-ppm                   = if PartsForMilion               = ? THEN tt-familia.per-ppm          ELSE PartsForMilion 
       tt-familia.tipo-formula              = if FormulationType              = ? THEN tt-familia.tipo-formula     ELSE FormulationType
       &ENDIF
       .

ASSIGN &IF DEFINED (bf_man_integra_aps) &THEN
       tt-familia.cod-pulmao                = if BufferCode                     = ? then tt-familia.cod-pulmao     else BufferCode                     
       tt-familia.cod-malha                 = if ProduceNetworkCode             = ? then tt-familia.cod-malha      else ProduceNetworkCode            
       tt-familia.politica-aps              = if PolicyAdvancedPlanningSchedule = ? then tt-familia.politica-aps   else PolicyAdvancedPlanningSchedule
       tt-familia.geracao-ordem             = if OrderGeneration                = ? then tt-familia.geracao-ordem  else OrderGeneration               
       tt-familia.qtde-fixa                 = if FixedMaximum                   = ? then tt-familia.qtde-fixa      else FixedMaximum                  
       tt-familia.lote-repos                = if ReplacedLot                    = ? then tt-familia.lote-repos     else ReplacedLot                   
       tt-familia.qtde-max                  = if QuantityMaximum                = ? then tt-familia.qtde-max       else QuantityMaximum               
       tt-familia.cons-produto              = if IsUsageProduct                 = ? then tt-familia.cons-produto   else IsUsageProduct                
       tt-familia.cons-saldo                = if IsIncludeOn-HandBalance        = ? then tt-familia.cons-saldo     else IsIncludeOn-HandBalance       
       tt-familia.mp-restrit                = if IsRestrictedRawMaterial        = ? then tt-familia.mp-restrit     else IsRestrictedRawMaterial       
       tt-familia.cons-consumo              = if IsIncludeForecastUsage         = ? then tt-familia.cons-consumo   else IsIncludeForecastUsage        
       &ENDIF
    
       &IF "{&bf_mat_versao_ems}" >= "2.08" &THEN
       /*
       tt-familia.ind-class-fam             = FamilyClassification 
       tt-familia.ind-inf-qtd               = IsFamilyQuantityInvoice 
       tt-familia.log-refugo-preco-fiscal   = IsScrapFiscalPrice 
       tt-familia.log-utilliza-batch-padrao = IsUseBatchStandard 
       */
       &ELSE
       overlay(tt-familia.char-1,19,1)      = IF FamilyClassification = ? THEN "" ELSE string(FamilyClassification)
       &ENDIF
       
       &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
       tt-familia.cdn-nat-desp              = if ExpenseType             = ?      then tt-familia.cdn-nat-desp             else ExpenseType            
       tt-familia.cod-classe-frete          = if FreightClassCode        = ?      then tt-familia.cod-classe-frete         else FreightClassCode       
       tt-familia.log-multi-malha           = if IsMultiNetwork          = ?      then tt-familia.log-multi-malha          else IsMultiNetwork         
       tt-familia.log-control-estoq-refugo  = if IsScrapInventoryControl = ?      then tt-familia.log-control-estoq-refugo else IsScrapInventoryControl
       tt-familia.cod-var-tempo-res         = if LeadTimeVariance        = ?      then tt-familia.cod-var-tempo-res        else LeadTimeVariance       
       tt-familia.qtd-min-reabast           = if MinimumReplenishment    = ?      then tt-familia.qtd-min-reabast          else MinimumReplenishment   
       tt-familia.pto-repos                 = if ReorderPoint            = ?      then tt-familia.pto-repos                else ReorderPoint           
       tt-familia.cod-reabast               = if Replenishment           = ?      then tt-familia.cod-reabast              else Replenishment          
       tt-familia.qtd-var-ressup            = if ReplenishmentQuantity   = ?      then tt-familia.qtd-var-ressup           else ReplenishmentQuantity  
       tt-familia.cdn-tipo-rec-desp         = if RevenueExpenseType      = ?      then tt-familia.cdn-tipo-rec-desp        else RevenueExpenseType     
       tt-familia.cod-item-refugo           = if ScrapItemCode           = ?      then tt-familia.cod-item-refugo          else ScrapItemCode          
       tt-familia.val-relac-refugo-item     = if ScrapItemLink           = ?      then tt-familia.val-relac-refugo-item    else ScrapItemLink          
       &ENDIF
       
       tt-familia.int-1                     = if RevenueExpenseType      = ?      then tt-familia.int-1                    else RevenueExpenseType

       tt-familia.num-id-familia            = if FamilyIdentify              = ?  then tt-familia.num-id-familia           else FamilyIdentify             
       tt-familia.horiz-fixo                = if FixedHorizon                = ?  then tt-familia.horiz-fixo               else FixedHorizon               
       tt-familia.periodo-fixo              = if FixedPeriod                 = ?  then tt-familia.periodo-fixo             else FixedPeriod                
       tt-familia.ind-cons-prv              = if ForecastConsumptionIndex    = ?  then tt-familia.ind-cons-prv             else ForecastConsumptionIndex   
       tt-familia.ind-cons-prv              = if ForecastConsumptionIndex_00 = ?  then tt-familia.ind-cons-prv             else ForecastConsumptionIndex_00
       tt-familia.ind-prev-demanda          = if ForecastDemand              = ?  then tt-familia.ind-prev-demanda         else ForecastDemand             
       tt-familia.cd-formula                = if FormulationCode             = ?  then tt-familia.cd-formula               else FormulationCode 
       .

ASSIGN tt-familia.ind-refugo                = if HandlingScrap                 = ? then tt-familia.ind-refugo              else HandlingScrap                
       tt-familia.nivel                     = if InspectionLevel               = ? then tt-familia.nivel                   else InspectionLevel              
       tt-familia.curva-abc                 = if IsABCPrinting                 = ? then tt-familia.curva-abc               else IsABCPrinting                
       tt-familia.atu-conf                  = if IsConfigUpdate                = ? then tt-familia.atu-conf                else IsConfigUpdate               
       tt-familia.conv-tempo-seg            = if IsConvertInsuranceTime        = ? then tt-familia.conv-tempo-seg          else IsConvertInsuranceTime       
       tt-familia.invent-cla-a              = if IsCountClassA                 = ? then tt-familia.invent-cla-a            else IsCountClassA                
       tt-familia.invent-cla-b              = if IsCountClassB                 = ? then tt-familia.invent-cla-b            else IsCountClassB                
       tt-familia.invent-cla-c              = if IsCountClassC                 = ? then tt-familia.invent-cla-c            else IsCountClassC                
       tt-familia.fraciona                  = if IsFractionizedQuantity        = ? then tt-familia.fraciona                else IsFractionizedQuantity       
       tt-familia.baixa-estoq               = if IsIssueInventory              = ? then tt-familia.baixa-estoq             else IsIssueInventory             
       tt-familia.contr-qualid              = if IsQualityControl              = ? then tt-familia.contr-qualid            else IsQualityControl             
       tt-familia.tipo-requis               = if IssueType                     = ? then tt-familia.tipo-requis             else IssueType                    
       tt-familia.loc-unica                 = if IsUniquePhysicalLocation      = ? then tt-familia.loc-unica               else IsUniquePhysicalLocation     
       tt-familia.log-atualiz-via-mmp       = if IsUpdatedViaMultiPlant        = ? then tt-familia.log-atualiz-via-mmp     else IsUpdatedViaMultiPlant       
       tt-familia.ind-imp-desc              = if ItemDescType                  = ? then tt-familia.ind-imp-desc            else ItemDescType                 
       tt-familia.var-mob-maior             = if LaborVariationOver            = ? then tt-familia.var-mob-maior           else LaborVariationOver           
       tt-familia.var-mob-menor             = if LaborVariationUnder           = ? then tt-familia.var-mob-menor           else LaborVariationUnder          
       tt-familia.ind-lista-mrp             = if ListForRequirementsScheduling = ? then tt-familia.ind-lista-mrp           else ListForRequirementsScheduling
       tt-familia.cod-localiz               = if LocationCode                  = ? then tt-familia.cod-localiz             else LocationCode                 
       tt-familia.nivel-apr-manut           = if MaintenanceEletronicApproval  = ? then tt-familia.nivel-apr-manut         else MaintenanceEletronicApproval 
       tt-familia.ressup-fabri              = if ManufacturingLeadTime         = ? then tt-familia.ressup-fabri            else ManufacturingLeadTime        
       tt-familia.res-cq-fabri              = if ManufacturingQualityControl   = ? then tt-familia.res-cq-fabri            else ManufacturingQualityControl  
       tt-familia.cap-est-fabr              = if MaxStorageCapacityPlant       = ? then tt-familia.cap-est-fabr            else MaxStorageCapacityPlant      
       tt-familia.vl-max-inv                = if MaxValueToCount               = ? then tt-familia.vl-max-inv              else MaxValueToCount              
       tt-familia.reporte-ggf               = if MfactureGeneralExpensesReport = ? then tt-familia.reporte-ggf             else MfactureGeneralExpensesReport
       tt-familia.lote-minimo               = if MinimumLot                    = ? then tt-familia.lote-minimo             else MinimumLot                   
       tt-familia.vl-min-inv                = if MinValueToCount               = ? then tt-familia.vl-min-inv              else MinValueToCount              
       tt-familia.lote-multipl              = if MultipleBatch                 = ? then tt-familia.lote-multipl            else MultipleBatch                
       tt-familia.perm-saldo-neg            = if NegativeBal                   = ? then tt-familia.perm-saldo-neg          else NegativeBal                  
       tt-familia.div-ordem                 = if OrderDivision                 = ? then tt-familia.div-ordem               else OrderDivision                
       tt-familia.emissao-ord               = if OrderPrinting                 = ? then tt-familia.emissao-ord             else OrderPrinting
       .

ASSIGN tt-familia.nivel-apr-compra          = if OrdersEletronicApproval          = ? then tt-familia.nivel-apr-compra     else OrdersEletronicApproval         
       tt-familia.cd-planejado              = if PlannerCode                      = ? then tt-familia.cd-planejado         else PlannerCode                     
       tt-familia.politica                  = if Policy                           = ? then tt-familia.politica             else Policy                          
       tt-familia.tp-adm-lote               = if PoliticsLotAdministration        = ? then tt-familia.tp-adm-lote          else PoliticsLotAdministration       
       tt-familia.prioridade                = if Priority                         = ? then tt-familia.prioridade           else Priority                        
       tt-familia.nr-linha                  = if ProductionLineCode               = ? then tt-familia.nr-linha             else ProductionLineCode              
       tt-familia.rep-prod                  = if ProductionReport                 = ? then tt-familia.rep-prod             else ProductionReport                
       tt-familia.nivel-apr-requis          = if ProductionTargetCalculateCrit_00 = ? then tt-familia.nivel-apr-requis     else ProductionTargetCalculateCrit_00
       tt-familia.res-int-comp              = if PurchaseLeadTime                 = ? then tt-familia.res-int-comp         else PurchaseLeadTime                
       tt-familia.res-cq-comp               = if PurchasingQualityControl         = ? then tt-familia.res-cq-comp          else PurchasingQualityControl        
       tt-familia.qt-max-ordem              = if QuantityMaximumOrder             = ? then tt-familia.qt-max-ordem         else QuantityMaximumOrder            
       tt-familia.var-req-menor             = if ReleaseHorizon                   = ? then tt-familia.var-req-menor        else ReleaseHorizon                  
       tt-familia.reporte-mob               = if ReportLabor                      = ? then tt-familia.reporte-mob          else ReportLabor                     
       tt-familia.classe-repro              = if ReschedulingClass                = ? then tt-familia.classe-repro         else ReschedulingClass               
       tt-familia.quant-segur               = if SafetyQuantity                   = ? then tt-familia.quant-segur          else SafetyQuantity                  
       tt-familia.tipo-est-seg              = if SafetyStockControlType           = ? then tt-familia.tipo-est-seg         else SafetyStockControlType          
       tt-familia.tempo-segur               = if SafetyTime                       = ? then tt-familia.tempo-segur          else SafetyTime                      
       tt-familia.tipo-sched                = if Scheduling                       = ? then tt-familia.tipo-sched           else Scheduling                      
       tt-familia.fator-refugo              = if ScrapFactor                      = ? then tt-familia.fator-refugo         else ScrapFactor                     
       tt-familia.codigo-orig               = if SourceCode                       = ? then tt-familia.codigo-orig          else SourceCode                      
       tt-familia.qtd-batch-padrao          = if StandardBatchSize                = ? then tt-familia.qtd-batch-padrao     else StandardBatchSize               
       tt-familia.moeda-padrao              = if StandardCurrCode                 = ? then tt-familia.moeda-padrao         else StandardCurrCode                
       tt-familia.cod-localiz               = if TargetListCode                   = ? then tt-familia.cod-localiz          else TargetListCode
       .                 


if  search("cep/ceapi018.r") = ? and search("cep/ceapi018.p") = ? then do:
        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro   = 4
               tt_log_erro.ttv_des_msg_ajuda  = "Programa execut†vel n∆o foi encontrado: cep/ceapi018.p"
               tt_log_erro.ttv_des_msg_erro   = "Programa execut†vel n∆o foi encontrado: cep/ceapi018.p".
end.
else do:
    RUN cep/ceapi018.p(INPUT  TABLE tt-familia,
                       INPUT  cTranAction,
                       OUTPUT TABLE RowErrors).

    IF FamilyStatus <> ? AND NOT CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH fam-uni-estab FIELDS(cod-obsol)
           WHERE fam-uni-estab.fm-codigo   = familia.fm-codigo EXCLUSIVE-LOCK:
             ASSIGN fam-uni-estab.cod-obsol = FamilyStatus.
        END.
    END.

    FOR EACH RowErrors NO-LOCK:
        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro   = RowErrors.ErrorNumber     
               tt_log_erro.ttv_des_msg_ajuda  = RowErrors.ErrorHelp
               tt_log_erro.ttv_des_msg_erro   = RowErrors.ErrorDescription.
    END.
end.
