
/*-------------------------------------------------
               AXSEP020UPC.i
-------------------------------------------------*/


PROCEDURE pi-executa-upc:
      
    IF  c-nom-prog-dpc-mg97  <> "" 
    OR  c-nom-prog-appc-mg97 <> "" 
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:
    
        FOR EACH tt-epc 
            WHERE tt-epc.cod-event = "AtualizaDados":U :
            DELETE tt-epc.
        END.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AtualizaDados":U
               tt-epc.cod-parameter = "ttEvento":U
               tt-epc.val-parameter = STRING(TEMP-TABLE ttEvento:HANDLE).
        
        {include/i-epc201.i "AtualizaDados"}
    END.

END PROCEDURE.