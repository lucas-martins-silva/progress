/******************************************************************************
***       
*** app/ap0520rp.i - Gera‡Æo Dados DIRF PJ - Chamada UPCïs.
***
******************************************************************************/

IF  c-nom-prog-upc-mg97 <> "" THEN DO:

    FOR EACH tt-epc WHERE tt-epc.cod-event = '{1}'.
        DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = '{1}' 
           tt-epc.cod-parameter = '{2}'
           tt-epc.val-parameter = {3}.

    {include/i-epc201.i '{1}'}   
    IF  RETURN-VALUE = 'NOK' THEN
        NEXT {4}.           

    FIND FIRST tt-epc NO-LOCK 
         WHERE tt-epc.cod-event = '{1}' NO-ERROR.

    IF  AVAIL tt-epc AND tt-epc.val-parameter = 'NOK' THEN 
        NEXT {4}.

END.

/* Fim Include */
