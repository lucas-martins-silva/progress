for each ngprocessmapping EXCLUSIVE-LOCK:                     
    delete ngprocessmapping.
end.
create ngprocessmapping.
assign ngprocessmapping.doctype = "Invoice"
       ngprocessmapping.program = "adapters/neogrid/rep/anere001"
       ngprocessmapping.version = "1.01.001".
create ngprocessmapping.
assign ngprocessmapping.doctype = "OrderCancel"
       ngprocessmapping.program = "adapters/neogrid/ccp/anecc008"
       ngprocessmapping.version = "1.01.001".
create ngprocessmapping.
assign ngprocessmapping.doctype = "OrderSalesCancel"
       ngprocessmapping.program = "adapters/neogrid/pdp/anepd006"
       ngprocessmapping.version = "1.01.001".
create ngprocessmapping.
assign ngprocessmapping.doctype = "OrderStatus"
       ngprocessmapping.program = "adapters/neogrid/pdp/anepd002"
       ngprocessmapping.version = "1.01.001".
create ngprocessmapping.
assign ngprocessmapping.doctype = "OrderUpdate"
       ngprocessmapping.program = "adapters/neogrid/pdp/anepd001"
       ngprocessmapping.version = "1.01.001".
create ngprocessmapping.
assign ngprocessmapping.doctype = "OrderUpdateSales"
       ngprocessmapping.program = "adapters/neogrid/ccp/anecc004"
       ngprocessmapping.version = "1.01.001".
create ngprocessmapping.
assign ngprocessmapping.doctype = "RequestInventoryReporting"
       ngprocessmapping.program = "adapters/neogrid/cep/anece001"
       ngprocessmapping.version = "1.01.001".
create ngprocessmapping.
assign ngprocessmapping.doctype = "ResponseQuote"
       ngprocessmapping.program = "adapters/neogrid/ccp/anecc002"
       ngprocessmapping.version = "1.01.001".


    
                                 
                 
                      
                      
                 
        
        
                     
                         
