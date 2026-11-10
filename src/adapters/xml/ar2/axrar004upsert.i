FOR EACH ttSiteItemCosting:

    CREATE tt-item-estab.
    ASSIGN tt-item-estab.cod-item      = ItemCode
           tt-item-estab.cod-estabelec = ttSiteItemCosting.SiteID.

    FOR EACH ttUnitValues
         WHERE ttUnitValues.ttSiteItemCostingID = ttSiteItemCosting.ttSiteItemCostingID :

        ASSIGN tt-item-estab.val-unit-mat-m[1] = ttUnitValues.MaterialValue
               tt-item-estab.val-unit-mat-m[2] = ttUnitValues.MaterialValue
               tt-item-estab.val-unit-mat-m[3] = ttUnitValues.MaterialValue
               tt-item-estab.val-unit-mob-m[1] = ttUnitValues.LaborValue    
               tt-item-estab.val-unit-mob-m[2] = ttUnitValues.LaborValue    
               tt-item-estab.val-unit-mob-m[3] = ttUnitValues.LaborValue    
               tt-item-estab.val-unit-ggf-m[1] = ttUnitValues.OverHeadValue 
               tt-item-estab.val-unit-ggf-m[2] = ttUnitValues.OverHeadValue 
               tt-item-estab.val-unit-ggf-m[3] = ttUnitValues.OverHeadValue. 
    END.
END.


RUN cep/ceapi015.p (INPUT TABLE tt-item-estab,
                    OUTPUT TABLE RowErrors).

IF CAN-FIND(FIRST RowErrors) THEN DO:
    FOR EACH RowErrors:
        RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber, 
                                         INPUT "business_error":U, 
                                         INPUT RowErrors.ErrorDescription).

    END.
END.

    
        
            
                
                    
                        
                            
