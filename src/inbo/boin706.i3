/*********************************************************
**
** INLCUDE BOIN706.I3 - Elimina handle da boin706.p 
**
**********************************************************/

    if  valid-handle(h-boin706) then do:
        delete procedure h-boin706 no-error.
        assign h-boin706 = ?.
    end.


/** FIM INCLUDE **/
