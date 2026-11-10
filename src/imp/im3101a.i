    if  valid-handle(h-acomp) then
        run pi-finalizar in h-acomp.

    run getTT-bo-erro in h-im3101a1 (output table tt-bo-erro append).
    
    if  valid-handle (h-im3101a1) then
        delete procedure h-im3101a1.  
    
    return "NOK":U.

/** imp/im3101a.i **/
