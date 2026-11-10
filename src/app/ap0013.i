/*******************************************************************************
***
*** app/ap0013.i - Gera Hist¢rico para o documento/movimento.
***
*******************************************************************************/
    
find first his-d-ap no-lock 
     where his-d-ap.ep-codigo   = {1}.ep-codigo 
     and   his-d-ap.cod-estabel = {1}.cod-estabel
     and   his-d-ap.cod-fornec  = {1}.cod-fornec 
     and   his-d-ap.cod-esp     = {1}.cod-esp 
     and   his-d-ap.serie       = {1}.serie 
     and   his-d-ap.nr-docto    = {1}.nr-docto 
     and   his-d-ap.parcela     = {1}.parcela 
     and   his-d-ap.sequencia   = 0 
     no-error.
        
if  not avail his-d-ap then do:
        
    run app/ap0013a.p (input "ADM201", output c-lista-destino).
        
    if  num-entries(c-lista-destino,";") > 1 then do:
        
        create his-d-ap.
        assign his-d-ap.ep-codigo   = {1}.ep-codigo 
               his-d-ap.cod-estabel = {1}.cod-estabel 
               his-d-ap.cod-fornec  = {1}.cod-fornec
               his-d-ap.cod-esp     = {1}.cod-esp 
               his-d-ap.serie       = {1}.serie 
               his-d-ap.nr-docto    = {1}.nr-docto 
               his-d-ap.parcela     = {1}.parcela 
               his-d-ap.dt-his-doc  = today 
               his-d-ap.sequencia   = 0.
                
        assign his-d-ap.horario = substring(string(time, "HH:MM:SS"), 01, 02) 
                                + substring(string(time, "HH:MM:SS"), 04, 02) 
                                + substring(string(time, "HH:MM:SS"), 07, 02).
            
        /*--- N£mero de Plantas ---*/
        assign his-d-ap.int-1 = num-entries(c-lista-destino,";").
            
        assign his-d-ap.historico = c-lista-destino.
            
        release his-d-ap no-error.
            
    end.        
end.
    
/* Fim de Include */
