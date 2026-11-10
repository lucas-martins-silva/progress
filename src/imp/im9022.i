/*******************************************************************************
**
**  IM9022.i - Integracao Importacao Compras
**
**  Objetivo: Elimina‡Æo de Processos/Cota‡äes Importa‡Æo.
**
*******************************************************************************/

def input parameter r-registro as rowid.
def input parameter c-registro as char.

def buffer b-pedido-compr for pedido-compr.
def buffer b-cotacao-item for cotacao-item.
def buffer b-cond-especif for cond-especif.

define variable h-bocx351 as handle.

{cdp/cdcfgmat.i} /* Pre-processador Magnus-EMS */

&if  "{&bf_mat_versao_ems}" >= "2.062" &then

{cxbo/bocx351.i tt-licenciam-import-oc}
{method/dbotterr.i}

&endif

if c-registro = "cotacao" then do:
   find b-cotacao-item where rowid(b-cotacao-item) = r-registro no-lock no-error.
   for each cotacao-item-cex where 
       cotacao-item-cex.numero-ordem = b-cotacao-item.numero-ordem and
       cotacao-item-cex.cod-emitente = b-cotacao-item.cod-emitente and
       cotacao-item-cex.it-codigo    = b-cotacao-item.it-codigo and
       &if defined(bf-mat-comex) &then                            
           cotacao-item-cex.data-cotacao = b-cotacao-item.data-cotacao EXCLUSIVE-LOCK: 
       &else
           cotacao-item-cex.seq-cotac    = b-cotacao-item.seq-cotac EXCLUSIVE-LOCK:                             
       &endif
              
      delete cotacao-item-cex.
   end.   
end.

if c-registro = "pedido" then do:
   find b-pedido-compr where rowid(b-pedido-compr) = r-registro no-lock no-error.
   for each cond-especif-cex where cond-especif-cex.num-pedido = b-pedido-compr.num-pedido EXCLUSIVE-LOCK: 
      delete cond-especif-cex.
   end.      
   find processo-imp where processo-imp.num-pedido = b-pedido-compr.num-pedido EXCLUSIVE-LOCK no-error.
   if avail processo-imp then do:
      for each historico-proc-imp where
          historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp and
          historico-proc-imp.cod-estabel = processo-imp.cod-estabel EXCLUSIVE-LOCK: 
          delete historico-proc-imp.
      end.     
      delete processo-imp.
   end.   

   &IF  "{&bf_mat_versao_ems}" >= "2.062" &THEN
   
       FOR EACH  despes-ped-compra
           WHERE despes-ped-compra.num-pedido = b-pedido-compr.num-pedido EXCLUSIVE-LOCK:
           DELETE despes-ped-compr.
       END.

   &ENDIF

end.

if  c-registro = "parcela":U then do:

    /* Licenciamento Importacao */
    &if  "{&bf_mat_versao_ems}" >= "2.062" &then
    
    if  not valid-handle (h-bocx351) then
        run cxbo/bocx351.p persistent set h-bocx351.

    run openQueryStatic in h-bocx351 (input "Main":U).

    find prazo-compra
        where rowid(prazo-compra) = r-registro no-lock no-error.
    if  avail prazo-compra then do:
    
        run piRetornaLi in h-bocx351 (input 3,
                                      input no,
                                      input ?,
                                      input ?,
                                      input ?,
                                      input prazo-compra.parcela,
                                      input yes,
                                      input yes,
                                      input prazo-compra.numero-ordem,
                                      input prazo-compra.numero-ordem,
                                      input " " , 
                                      input " ",
                                      input " ",
                                      input " ",
                                      input " ",
                                      input " ",
                                      output table tt-licenciam-import-oc).
    
        for first tt-licenciam-import-oc no-lock: end.
        if  avail tt-licenciam-import-oc then do:
    
            run emptyRowErrors in h-bocx351.
            run emptyRowObject in h-bocx351.
    
            run goToKey in h-bocx351 (input tt-licenciam-import-oc.numero-ordem,
                                      input tt-licenciam-import-oc.parcela).
            if  return-value = "OK" then do:

                run deleteRecord   in h-bocx351.
                if  return-value = "NOK":U then do:
        
                    run getRowErrors in h-bocx351 (output table RowErrors).
        
                    for each  RowErrors 
                        where RowErrors.errorType = "INTERNAL":U:
                        delete RowErrors.
                    end.
        
                    if  can-find (first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
                        undo, leave.
                end.
            end.
        end.
    end.
    
    if  valid-handle (h-bocx351) then do:
        delete procedure h-bocx351.
        assign h-bocx351 = ?.
    end.

    &endif
end.
