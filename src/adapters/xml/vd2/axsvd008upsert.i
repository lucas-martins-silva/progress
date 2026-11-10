
PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    
    define input  parameter pTranAction          as character no-undo. /* add/upd */
    define input  parameter pCustomerGroupRowID  as rowid     no-undo.  
    define output parameter table for tt_log_erro.
    
    /*PARAMETERS - END*/
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    empty temp-table tt_log_erro no-error.
    empty temp-table tt-gr-cli   no-error.
     
    find first gr-cli
        where rowid(gr-cli) = pCustomerGroupRowID no-lock no-error.
    if  avail gr-cli then do:

        create tt-gr-cli.
        buffer-copy gr-cli to tt-gr-cli.
        
        run PIUpsert (input  pTranAction,
                      input  table tt-gr-cli,
                      output table tt_log_erro).
    end.
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.






