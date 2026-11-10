PROCEDURE PITransDelete:

    /*PARAMETERS - BEGIN*/

    define input  parameter i-cod-gr-cli like gr-cli.cod-gr-cli no-undo. 
    define input  parameter c-descricao  like gr-cli.descricao  no-undo. 
    define output parameter table for tt_log_erro.
    
    /*PARAMETERS - END*/
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    empty temp-table tt_log_erro no-error.
    
    run PIDelete (input i-cod-gr-cli,
                  input c-descricao, 
                  output table tt_log_erro).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



