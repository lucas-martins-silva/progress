/*********************************************************
**
** INLCUDE BOIN709.I3 - Elimina handle da boin709.p 
**
**********************************************************/

    if  valid-handle(h-boin709) then do:
        delete procedure h-boin709 no-error.
        assign h-boin709 = ?.
    end.


/** FIM INCLUDE **/
