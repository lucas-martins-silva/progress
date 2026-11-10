/******************************************************************************
***
*** app/ap0040.i - Grava Hist¢rico das Altera‡äes.
***
******************************************************************************/

find first his-d-ap exclusive-lock
     where his-d-ap.ep-codigo   = {1}.ep-codigo
     and   his-d-ap.cod-estabel = {1}.cod-estabel
     and   his-d-ap.cod-esp     = {1}.cod-esp
     and   his-d-ap.serie       = {1}.serie
     and   his-d-ap.nr-docto    = {1}.nr-docto
     and   his-d-ap.parcela     = {1}.parcela
     and   his-d-ap.cod-fornec  = {1}.cod-fornec
     and   his-d-ap.dt-his-doc  = today
     and   his-d-ap.sequencia   = 999999
     no-error.
        
if  not avail his-d-ap then   
    run pi-cria-historico.

PROCEDURE pi-cria-historico:    
        
    def var c-hora as char no-undo.
        
    create his-d-ap.
    assign his-d-ap.ep-codigo   = {1}.ep-codigo
           his-d-ap.cod-estabel = {1}.cod-estabel
           his-d-ap.cod-fornec  = {1}.cod-fornec
           his-d-ap.cod-esp     = {1}.cod-esp
           his-d-ap.serie       = {1}.serie
           his-d-ap.nr-docto    = {1}.nr-docto
           his-d-ap.parcela     = {1}.parcela
           his-d-ap.dt-his-doc  = today
           his-d-ap.sequencia   = 999999 no-error.
           
    assign c-hora           = string(time, "HH:MM:SS")
           his-d-ap.horario = substring(c-hora, 01,02)
                            + substring(c-hora, 04,02)
                            + substring(c-hora, 07,02) no-error.
        
END PROCEDURE.
